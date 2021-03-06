{ stdenv
, fetchFromGitHub
, fetchpatch
, cmake
, git

, llvmPackages_9
, spirv-llvm-translator

, buildWithPatches ? true
}:

let
  llvmPkgs = llvmPackages_9 // {
    inherit spirv-llvm-translator;
  };

  inherit (stdenv.lib) getVersion;

  addPatches = component: pkg:
    with builtins; with stdenv.lib;
    let path = "${passthru.patchesOut}/${component}";
    in pkg.overrideAttrs (super: {
      postPatch = (if super ? postPatch then super.postPatch + "\n" else "") + ''
        for p in ${path}/*
        do
          patch -p1 -i "$p"
        done
      '';
    });

  passthru = rec {

    clang-unwrapped = addPatches "clang" llvmPkgs.clang-unwrapped;

    clang = llvmPkgs.clang.override {
      cc = clang-unwrapped;
    };

    patchesOut = stdenv.mkDerivation rec {
      pname = "opencl-clang-patches";
      inherit (lib) version src patches;
      installPhase = ''
        [ -d patches ] && cp -r patches/ $out || mkdir $out
        mkdir -p $out/clang $out/spirv
      '';
    };

    spirv-llvm-translator = addPatches "spirv" llvmPkgs.spirv-llvm-translator;

  };

  lib = let
    inherit (llvmPkgs) llvm;
    inherit (if buildWithPatches then passthru else llvmPkgs) clang-unwrapped spirv-llvm-translator;
  in
    stdenv.mkDerivation rec {
      pname = "opencl-clang";
      version = "9.0.0"; # match LLVM version, spirv-llvm-translator version too?

      inherit passthru;

      src = fetchFromGitHub {
        owner = "intel";
        repo = "opencl-clang";
        rev = "v${version}";
        sha256 = "1n5lz40cym3hmrldnia2a2acxp67c2nqsd4flxsdc7k4nwshq6xx";
      };

      patches = [
      # Build script tries to find Clang OpenCL headers under ${llvm}
      # Work around it by specifying that directory manually.
        ./opencl-headers-dir.patch
      ];

      nativeBuildInputs = [ cmake git ];

      buildInputs = [ clang-unwrapped llvm spirv-llvm-translator ];

      cmakeFlags = [
        "-DPREFERRED_LLVM_VERSION=${getVersion llvm}"
        "-DOPENCL_HEADERS_DIR=${clang-unwrapped}/lib/clang/${getVersion clang-unwrapped}/include/"

        "-DLLVMSPIRV_INCLUDED_IN_LLVM=OFF"
        "-DSPIRV_TRANSLATOR_DIR=${spirv-llvm-translator}"
      ];

      meta = with stdenv.lib; {
        homepage    = https://github.com/intel/opencl-clang/;
        description = "A clang wrapper library with an OpenCL-oriented API and the ability to compile OpenCL C kernels to SPIR-V modules";
        license     = licenses.ncsa;
        platforms   = platforms.all;
        maintainers = with maintainers; [ gloaming ];
      };
    };
in
  lib
