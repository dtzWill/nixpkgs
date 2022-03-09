{ lib, stdenv, llvm_meta
, buildLlvmTools
, monorepoSrc, runCommand
, cmake
, libllvm
, version

# TODO: python bindings
# TODO: Shared lib, MLIR-C?
# TODO: ROCm, CUDA ?
, enableVulkan ? true
, vulkan-headers
, vulkan-loader
}:

# Enumerate the utilities to build + install
# LLVM_{BUILD,INSTALL}_UTILS=ON doesn't seem to work
let bins = map (n: "mlir-" + n) ([
    "linalg-ods-yaml-gen" "tblgen"
    "lsp-server" "opt" "pdll" "reduce" "translate"
    "spirv-cpu-runner"
  ] ++ lib.optional (stdenv.hostPlatform == stdenv.buildPlatform) "cpu-runner"
    ++ lib.optional enableVulkan "vulkan-runner");
in
stdenv.mkDerivation rec {
  pname = "mlir";
  inherit version;

  src = runCommand "${pname}-src-${version}" {} ''
    mkdir -p "$out"
    cp -r ${monorepoSrc}/cmake "$out"
    cp -r ${monorepoSrc}/${pname} "$out"
  '';

  sourceRoot = "${src.name}/${pname}";

  outputs = [ "out" "dev" ];

  nativeBuildInputs = [ cmake ];
  buildInputs = [ libllvm ]
    ++ lib.optionals enableVulkan [ vulkan-headers vulkan-loader ];

  cmakeFlags = [
    # Documentation suggests packagers may wish to disable, do so until needed
    "-DMLIR_INSTALL_AGGREGATE_OBJECTS=OFF"
    # Runners:
    "-DMLIR_ENABLE_SPIRV_CPU_RUNNER=ON"
  ] ++ lib.optional enableVulkan "-DMLIR_ENABLE_VULKAN_RUNNER=ON";

  # Don't rely on being built with LLVM, fix native check
  #postPatch = lib.optionalString (stdenv.hostPlatform == stdenv.buildPlatform) ''
  #  for x in **/CMakeLists.txt; do
  #    substituteInPlace "$x" --replace 'if(TARGET ''${LLVM_NATIVE_ARCH})' 'if (1)'
  #  done
  #'';

  postBuild = ''
    make ${lib.concatStringsSep " " bins} -j$NIX_BUILD_CORES -l$NIX_BUILD_CORES
  '';

  postInstall = ''
    install -Dm755 -t $out/bin ${lib.concatMapStringsSep " " (x: "bin/${x}") bins}
  '';

  meta = llvm_meta // {
    homepage = "https://mlir.llvm.org";
    description = "Multi-Level Intermediate Representation";
  };
}

