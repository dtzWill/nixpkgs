{ stdenv
, fetch
, fetchpatch
, cmake
, python
, libffi
, libbfd
, libxml2
, valgrind
, ncurses
, version
, release_version
, zlib
, compiler-rt_src
, libcxxabi
, debugVersion ? false
, enableManpages ? false
, enableSharedLibraries ? true
, enableWasm ? true
, darwin
, buildPackages
, writeText
}:

with stdenv.lib;
let
  src = fetch "llvm" "0224xvfg6h40y5lrbnb9qaq3grmdc5rg00xq03s1wxjfbf8krx8z";

  cmakeToolchainFile = writeText "${stdenv.hostPlatform.config}-toolchain.cmake" ''
    SET(CMAKE_SYSTEM_NAME Linux)

    SET(CMAKE_CXX_COMPILER ${stdenv.cc.targetPrefix}c++)
    SET(CMAKE_C_COMPILER ${stdenv.cc.targetPrefix}cc)
    SET(CMAKE_AR ${getBin stdenv.cc.bintools.bintools}/bin/${stdenv.cc.targetPrefix}ar)
    SET(CMAKE_RANLIB ${getBin stdenv.cc.bintools.bintools}/bin/${stdenv.cc.targetPrefix}ranlib)
    SET(CMAKE_STRIP ${getBin stdenv.cc.bintools.bintools}/bin/${stdenv.cc.targetPrefix}strip)
  '';

  # Used when creating a version-suffixed symlink of libLLVM.dylib
  shortVersion = with stdenv.lib;
    concatStringsSep "." (take 2 (splitString "." release_version));
in stdenv.mkDerivation (rec {
  name = "llvm-${version}";

  unpackPhase = ''
    unpackFile ${src}
    mv llvm-${version}* llvm
    sourceRoot=$PWD/llvm
  '';
#    unpackFile ${compiler-rt_src}
#    mv compiler-rt-* $sourceRoot/projects/compiler-rt
#  '';

  outputs = [ "out" "python" ]
    ++ stdenv.lib.optional enableSharedLibraries "lib";

  depsBuildBuild = [ buildPackages.stdenv.cc ];

  nativeBuildInputs = [ cmake python ]
    ++ stdenv.lib.optional enableManpages python.pkgs.sphinx;

  buildInputs = [ libxml2 libffi ]
    ++ stdenv.lib.optionals stdenv.isDarwin [ libcxxabi ];

  propagatedBuildInputs = [ ncurses zlib ];

  # TSAN requires XPC on Darwin, which we have no public/free source files for. We can depend on the Apple frameworks
  # to get it, but they're unfree. Since LLVM is rather central to the stdenv, we patch out TSAN support so that Hydra
  # can build this. If we didn't do it, basically the entire nixpkgs on Darwin would have an unfree dependency and we'd
  # get no binary cache for the entire platform. If you really find yourself wanting the TSAN, make this controllable by
  # a flag and turn the flag off during the stdenv build.
  postPatch = stdenv.lib.optionalString stdenv.isDarwin ''
    substituteInPlace ./projects/compiler-rt/cmake/config-ix.cmake \
      --replace 'set(COMPILER_RT_HAS_TSAN TRUE)' 'set(COMPILER_RT_HAS_TSAN FALSE)'

    substituteInPlace cmake/modules/AddLLVM.cmake \
      --replace 'set(_install_name_dir INSTALL_NAME_DIR "@rpath")' "set(_install_name_dir INSTALL_NAME_DIR "$lib/lib")" \
      --replace 'set(_install_rpath "@loader_path/../lib" ''${extra_libdir})' ""
  ''
  # Patch llvm-config to return correct library path based on --link-{shared,static}.
  + stdenv.lib.optionalString (enableSharedLibraries) ''
    substitute '${./llvm-outputs.patch}' ./llvm-outputs.patch --subst-var lib
    patch -p1 < ./llvm-outputs.patch
  '' + ''
    # FileSystem permissions tests fail with various special bits
    substituteInPlace unittests/Support/CMakeLists.txt \
      --replace "Path.cpp" ""
    rm unittests/Support/Path.cpp
  '' + stdenv.lib.optionalString stdenv.hostPlatform.isMusl ''
    patch -p1 -i ${../TLI-musl.patch}
    substituteInPlace unittests/Support/CMakeLists.txt \
      --replace "add_subdirectory(DynamicLibrary)" ""
    rm unittests/Support/DynamicLibrary/DynamicLibraryTest.cpp
  '';

  # hacky fix: created binaries need to be run before installation
  preBuild = ''
    mkdir -p $out/
    ln -sv $PWD/lib $out
  '';

  cmakeFlags = with stdenv; [
    "-DCMAKE_BUILD_TYPE=${if debugVersion then "Debug" else "Release"}"
    "-DLLVM_INSTALL_UTILS=ON"  # Needed by rustc
    "-DLLVM_BUILD_TESTS=ON"
    "-DLLVM_ENABLE_FFI=ON"
    "-DLLVM_ENABLE_RTTI=ON"
    #"-DCOMPILER_RT_INCLUDE_TESTS=OFF" # FIXME: requires clang source code
  ]
  ++ stdenv.lib.optional enableSharedLibraries
    "-DLLVM_LINK_LLVM_DYLIB=ON"
  ++ stdenv.lib.optionals enableManpages [
    "-DLLVM_BUILD_DOCS=ON"
    "-DLLVM_ENABLE_SPHINX=ON"
    "-DSPHINX_OUTPUT_MAN=ON"
    "-DSPHINX_OUTPUT_HTML=OFF"
    "-DSPHINX_WARNINGS_AS_ERRORS=OFF"
  ]
  ++ stdenv.lib.optional (!isDarwin)
    "-DLLVM_BINUTILS_INCDIR=${libbfd.dev}/include"
  ++ stdenv.lib.optionals (isDarwin) [
    "-DLLVM_ENABLE_LIBCXX=ON"
    "-DCAN_TARGET_i386=false"
  ]
  ++ stdenv.lib.optionals stdenv.hostPlatform.isMusl [
    "-DLLVM_HOST_TRIPLE=${stdenv.hostPlatform.config}"
    "-DLLVM_DEFAULT_TARGET_TRIPLE=${stdenv.targetPlatform.config}"
    "-DTARGET_TRIPLE=${stdenv.targetPlatform.config}"
  ]
  ++stdenv.lib.optionals (stdenv.hostPlatform != stdenv.buildPlatform) [
    "-DCMAKE_CROSSCOMPILING=ON"
    "-DLLVM_HOST_TRIPLE=${stdenv.hostPlatform.config}"
    "-DLLVM_DEFAULT_TARGET_TRIPLE=${stdenv.targetPlatform.config}"
    "-DTARGET_TRIPLE=${stdenv.targetPlatform.config}"
    "-DCMAKE_SYSTEM_NAME=Linux"
    # From docs/GettingStarted.rst
    "-DLLVM_BUILD_RUNTIME=OFF"
    "-DLLVM_INCLUDE_TESTS=OFF"
    "-DLLVM_BUILD_TESTS=OFF"
    "-DLLVM_INCLUDE_EXAMPLES=OFF"
    "-DLLVM_ENABLE_BACKTRACES=OFF"

    #"-DCMAKE_CXX_COMPILER=${stdenv.cc.
    # These should be native tools,
    # toolchain file describes the cross tools.
    "-DCMAKE_CXX_COMPILER=${getBin buildPackages.stdenv.cc}/bin/${stdenv.cc.nativePrefix}c++"
    "-DCMAKE_C_COMPILER=${getBin buildPackages.stdenv.cc}/bin/${stdenv.cc.nativePrefix}cc"
    "-DCMAKE_AR=${getBin buildPackages.stdenv.cc.bintools.bintools}/bin/${stdenv.cc.nativePrefix}ar"
    "-DCMAKE_RANLIB=${getBin buildPackages.stdenv.cc.bintools.bintools}/bin/${stdenv.cc.nativePrefix}ranlib"
    "-DCMAKE_STRIP=${getBin buildPackages.stdenv.cc.bintools.bintools}/bin/${stdenv.cc.nativePrefix}strip"

    "-DCMAKE_TOOLCHAIN_FILE=${cmakeToolchainFile}"

    "--trace"
  ] ++ stdenv.lib.optional enableWasm
   "-DLLVM_EXPERIMENTAL_TARGETS_TO_BUILD=WebAssembly"
  ;

  postBuild = ''
    rm -fR $out

    paxmark m bin/{lli,llvm-rtdyld}
    paxmark m unittests/ExecutionEngine/MCJIT/MCJITTests
    paxmark m unittests/ExecutionEngine/Orc/OrcJITTests
    paxmark m unittests/Support/SupportTests
    paxmark m bin/lli-child-target
  '';

  preCheck = ''
    export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$PWD/lib
  '';

  postInstall = ''
    mkdir -p $python/share
    mv $out/share/opt-viewer $python/share/opt-viewer
  ''
  + stdenv.lib.optionalString enableSharedLibraries ''
    moveToOutput "lib/libLLVM-*" "$lib"
    moveToOutput "lib/libLLVM${stdenv.hostPlatform.extensions.sharedLibrary}" "$lib"
    substituteInPlace "$out/lib/cmake/llvm/LLVMExports-${if debugVersion then "debug" else "release"}.cmake" \
      --replace "\''${_IMPORT_PREFIX}/lib/libLLVM-" "$lib/lib/libLLVM-"
  ''
  + stdenv.lib.optionalString (stdenv.isDarwin && enableSharedLibraries) ''
    substituteInPlace "$out/lib/cmake/llvm/LLVMExports-${if debugVersion then "debug" else "release"}.cmake" \
      --replace "\''${_IMPORT_PREFIX}/lib/libLLVM.dylib" "$lib/lib/libLLVM.dylib"
    ln -s $lib/lib/libLLVM.dylib $lib/lib/libLLVM-${shortVersion}.dylib
    ln -s $lib/lib/libLLVM.dylib $lib/lib/libLLVM-${release_version}.dylib
  '';

  doCheck = stdenv.isLinux && (!stdenv.isi686);

  checkTarget = "check-all";

  enableParallelBuilding = true;

  passthru.src = src;

  meta = {
    description = "Collection of modular and reusable compiler and toolchain technologies";
    homepage    = http://llvm.org/;
    license     = stdenv.lib.licenses.ncsa;
    maintainers = with stdenv.lib.maintainers; [ lovek323 raskin viric dtzWill ];
    platforms   = stdenv.lib.platforms.all;
  };
} // stdenv.lib.optionalAttrs enableManpages {
  name = "llvm-manpages-${version}";

  buildPhase = ''
    make docs-llvm-man
  '';

  propagatedBuildInputs = [];

  installPhase = ''
    make -C docs install
  '';

  outputs = [ "out" ];

  doCheck = false;

  meta.description = "man pages for LLVM ${version}";
})
