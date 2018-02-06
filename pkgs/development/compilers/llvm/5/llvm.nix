{ stdenv
, buildPackages
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
, enableAssertions ? true
, enableManpages ? false
, enableSharedLibraries ? true
, darwin
}:

let
  src = fetch "llvm" "1c07i0b61j69m578lgjkyayg419sh7sn40xb3j112nr2q2gli9sz";

  # Used when creating a version-suffixed symlink of libLLVM.dylib
  shortVersion = with stdenv.lib;
    concatStringsSep "." (take 2 (splitString "." release_version));

  crossCompiling = stdenv.buildPlatform != stdenv.hostPlatform;
  llvmArch =
    let target = stdenv.targetPlatform;
    in     if target.isAarch64 then "AARCH64"
      else if target.isArm     then "ARM"
      else if target.isx86_64  then "X86"
      else throw "unknown platform";
  cmakeBuildType = if debugVersion then "Debug" else "Release";

in stdenv.mkDerivation (rec {
  name = "llvm-${version}";

  unpackPhase = ''
    unpackFile ${src}
    mv llvm-${version}* llvm
    sourceRoot=$PWD/llvm
    unpackFile ${compiler-rt_src}
    mv compiler-rt-* $sourceRoot/projects/compiler-rt
  '';

  outputs = [ "out" "python" ]
    ++ stdenv.lib.optional enableSharedLibraries "lib";

  nativeBuildInputs = [ cmake python ]
    ++ stdenv.lib.optional enableManpages python.pkgs.sphinx
       # for build tablegen
    ++ stdenv.lib.optional crossCompiling buildPackages.llvm_5;

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

    # Revert compiler-rt commit that makes codesign mandatory
    patch -p1 -i ${./compiler-rt-codesign.patch} -d projects/compiler-rt
  '' + stdenv.lib.optionalString stdenv.isAarch64 ''
    patch -p0 < ${../aarch64.patch}
  '' + stdenv.lib.optionalString stdenv.hostPlatform.isMusl ''
    patch -p1 -i ${../TLI-musl.patch}
    substituteInPlace unittests/Support/CMakeLists.txt \
      --replace "add_subdirectory(DynamicLibrary)" ""
    rm unittests/Support/DynamicLibrary/DynamicLibraryTest.cpp
  '' + ''
    # Breaks, expecting plugins I think?
    # /nix/store/rfqm5644sqag55rzblvm8n4am20bny1l-binutils-2.28.1/bin/ld.gold: error: /build/llvm/build/test/tools/gold/X86/Output/common.ll.tmp2native.o: incompatible target
    rm test/tools/gold/X86/common.ll
  '';

  # hacky fix: created binaries need to be run before installation
  preBuild = ''
    mkdir -p $out/
    ln -sv $PWD/lib $out
  '';

  inherit cmakeBuildType;
  cmakeFlags = with stdenv; [
    "-DLLVM_INSTALL_UTILS=ON"  # Needed by rustc
    "-DLLVM_BUILD_TESTS=ON"
    "-DLLVM_ENABLE_FFI=ON"
    "-DLLVM_ENABLE_RTTI=ON"
    "-DCOMPILER_RT_INCLUDE_TESTS=OFF" # FIXME: requires clang source code

    # Always set triple
    "-DLLVM_HOST_TRIPLE=${stdenv.hostPlatform.config}"
    "-DLLVM_DEFAULT_TARGET_TRIPLE=${stdenv.targetPlatform.config}"
    "-DTARGET_TRIPLE=${stdenv.targetPlatform.config}"

    "-DLLVM_ENABLE_ASSERTIONS=${if enableAssertions then "ON" else "OFF"}"
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
  ++ stdenv.lib.optionals crossCompiling [
    "-DCMAKE_CROSSCOMPILING=True"
    "-DLLVM_TABLEGEN=${buildPackages.llvm_5}/bin/llvm-tblgen"
    "-DCLANG_TABLEGEN=${buildPackages.llvm_5}/bin/llvm-tblgen"
    "-DLLVM_TARGET_ARCH=${llvmArch}"
    #"-DLLVM_TARGETS_TO_BUILD=${llvmArch}"
  ]
  ++ stdenv.lib.optionals stdenv.hostPlatform.isMusl [
    "-DCOMPILER_RT_BUILD_SANITIZERS=OFF"
    "-DCOMPILER_RT_BUILD_XRAY=OFF"
  ];

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
    substituteInPlace "$out/lib/cmake/llvm/LLVMExports-${stdenv.lib.toLower cmakeBuildType}.cmake" \
      --replace "\''${_IMPORT_PREFIX}/lib/libLLVM-" "$lib/lib/libLLVM-"
  ''
  + stdenv.lib.optionalString (stdenv.isDarwin && enableSharedLibraries) ''
    substituteInPlace "$out/lib/cmake/llvm/LLVMExports-${stdenv.lib.toLower cmakeBuildType}.cmake" \
      --replace "\''${_IMPORT_PREFIX}/lib/libLLVM.dylib" "$lib/lib/libLLVM.dylib"
    ln -s $lib/lib/libLLVM.dylib $lib/lib/libLLVM-${shortVersion}.dylib
    ln -s $lib/lib/libLLVM.dylib $lib/lib/libLLVM-${release_version}.dylib
  '';

  doCheck = stdenv.isLinux && stdenv.isx86_64 &&
    stdenv.hostPlatform == stdenv.buildPlatform &&
    stdenv.buildPlatform == stdenv.targetPlatform;

  checkTarget = "check-all";

  enableParallelBuilding = true;

  # separateDebugInfo = true;

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
