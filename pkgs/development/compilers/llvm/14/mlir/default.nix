{ lib, stdenv, llvm_meta
, monorepoSrc, runCommand
, cmake
, libllvm
, version
, lit

# TODO: python bindings
# TODO: ROCm, CUDA ?
, enableRunners ? stdenv.hostPlatform == stdenv.buildPlatform
, enableVulkan ? enableRunners
, vulkan-headers
, vulkan-loader
}:

stdenv.mkDerivation rec {
  pname = "mlir";
  inherit version;

  src = runCommand "${pname}-src-${version}" {} ''
    mkdir -p "$out"
    cp -r ${monorepoSrc}/cmake "$out"
    cp -r ${monorepoSrc}/${pname} "$out"
    mkdir -p "$out/llvm/utils" "$out/llvm/include"
    cp -r ${monorepoSrc}/llvm/utils/unittest -t "$out/llvm/utils"
    cp -r ${monorepoSrc}/llvm/include -t "$out/llvm"
  '';

  sourceRoot = "${src.name}/${pname}";

  patches = [
    ./gnu-install-dirs.patch
    ./add_mlir_tool.patch
    ./mlir-standalone-test.patch
  ];

  outputs = [ "out" "lib" "dev" ];

  nativeBuildInputs = [ cmake ];
  buildInputs = [ libllvm ]
    ++ lib.optionals enableVulkan [ vulkan-headers vulkan-loader ];

  cmakeFlags = [
    "-DLLVM_BUILD_MAIN_SRC_DIR=${src}/llvm"
    "-DMLIR_INCLUDE_TESTS=ON"
    "-DLLVM_EXTERNAL_LIT=${lit}/bin/lit"
    "-DLLVM_BUILD_UTILS=ON"
    # Documentation suggests packagers may wish to disable, do so until needed
    "-DMLIR_INSTALL_AGGREGATE_OBJECTS=OFF"
  ] ++ lib.optionals enableRunners ([
    "-DMLIR_ENABLE_SPIRV_CPU_RUNNER=ON"
  ] ++ lib.optional enableVulkan "-DMLIR_ENABLE_VULKAN_RUNNER=ON");

  # Patch around check for being built native (maybe because not built w/LLVM?)
  postPatch = lib.optionalString enableRunners ''
    for x in lib/CAPI/CMakeLists.txt lib/CMakeLists.txt python/CMakeLists.txt test/CAPI/CMakeLists.txt test/CMakeLists.txt tools/CMakeLists.txt unittests/CMakeLists.txt; do
      substituteInPlace "$x" \
        --replace 'if(TARGET ''${LLVM_NATIVE_ARCH})' 'if (1)'
    done
    substituteInPlace test/CMakeLists.txt \
        --replace 'if(NOT TARGET ''${LLVM_NATIVE_ARCH})' 'if (0)'

    substituteInPlace test/lit.site.cfg.py.in --replace '@MLIR_ENABLE_VULKAN_RUNNER@' '0'
  '' + ''
    patchShebangs test/mlir-reduce/{failure-,}test.sh

    # Copy over LLVM's TableGen module, so we can patch it:
    # (give it a unique name just to be sure it's what is used)
    cp ${lib.getDev libllvm}/lib/cmake/llvm/TableGen.cmake MLIRTableGen.cmake
    patch -p1 -i ${./llvm-tablegen-install-path.patch}

    # Patch cmake to look in current directory for modules, so our patched module is found
    substituteInPlace CMakeLists.txt \
      --replace "include(TableGen)" "include(MLIRTableGen)" \
      --replace 'set(CMAKE_MODULE_PATH ''${CMAKE_MODULE_PATH} ''${LLVM_CMAKE_DIR})' \
                'set(CMAKE_MODULE_PATH ''${CMAKE_CURRENT_SOURCE_DIR} ''${CMAKE_MODULE_PATH} ''${LLVM_CMAKE_DIR})'
  '';

  doCheck = true;

  checkTarget = "check-mlir";

  postInstall = ''
    # Install editor bits
    mkdir -p $out/share/vim-plugins/
    cp -r ../utils/vim $out/share/vim-plugins/mlir
    install -Dt $out/share/emacs/site-lisp ../utils/emacs/mlir-mode.el
  '';

  meta = llvm_meta // {
    homepage = "https://mlir.llvm.org";
    description = "Multi-Level Intermediate Representation";
    longDescription = ''
      The MLIR project is a novel approach to building reusable and extensible
      compiler infrastructure.
      MLIR aims to address software fragmentation, improve compilation for
      heterogeneous hardware, significantly reduce the cost of building domain
      specific compilers, and aid in connecting existing compilers together.
    '';
  };
}

