{ stdenv, fetchFromGitHub
, cmake, ninja
, python3, which, swig
, libxml2, libffi, libbfd
, libedit
, ncurses, zlib
, enableProjects ? [
  "clang" "libcxx" "libcxxabi" "libunwind" "lldb"
  "compiler-rt" "lld" "polly" "debuginfo-tests"
 ] ++ [ "pstore" /* rld */ ]
}:

let
src = fetchFromGitHub {
  owner = "SNSystems";
  repo = "llvm-project-prepo";
  #rev = "llvmorg-8.0.0";
  rev = "4602820f34f7d3c8340c46c526b0312c96d8b3ed";
  sha256 = "1qwlii1igphpcvf28dwbf5ap8ay7fvy5w9arvb0p3yaqxxljl9vg";
};
pstore_src = fetchFromGitHub {
  owner = "SNSystems";
  name = "pstore";
  repo = "pstore";
  #rev = "llvmorg-8.0.0";
  rev = "573d21eb20c15e8cd8fdd656979b0417eb5d7d67"; # 2019-09-06
  sha256 = "1ssr7acr1l91rg5ka64qya1yp9z6zivs2gij6cv93rz1kydilgsd";
};
self = stdenv.mkDerivation rec {
  pname = "llvm-project-prepo";
  #version = "8.0.0";
  version = "2019-08-23";

  srcs = [ src pstore_src ];

  sourceRoot = "source";

  nativeBuildInputs = [ cmake ninja python3 which swig ];

  buildInputs = [ libxml2 libffi libbfd libedit ];
  propagatedBuildInputs = [ ncurses zlib ];

  preConfigure = "ln -rs ../pstore; cd llvm";

  postPatch = ''
    patch -p1 -d clang -i ${clang/purity.patch}
    sed -i -e 's/DriverArgs.hasArg(options::OPT_nostdlibinc)/true/' \
           -e 's/Args.hasArg(options::OPT_nostdlibinc)/true/' \
           clang/lib/Driver/ToolChains/*.cpp

  '';

  cmakeFlags = [
    #"-DLLVM_ENABLE_PROJECTS=clang;libcxx;libcxxabi;libunwind;lldb;compiler-rt;lld;polly;pstore;rld;debuginfo-tests"
    "-DLLVM_ENABLE_PROJECTS=${builtins.concatStringsSep ";" enableProjects}"
    "-DLLVM_TARGETS_TO_BUILD=host"
    "-DLLVM_TOOL_CLANG_TOOLS_EXTRA_BUILD=OFF"

    "-DLLVM_HOST_TRIPLE=${stdenv.hostPlatform.config}"
    "-DLLVM_DEFAULT_TARGET_TRIPLE=${stdenv.hostPlatform.config}"

    # Can't set this, pstore wants to be statically linked
    # XXX: investigate!
    #"-DLLVM_LINK_LLVM_DYLIB=ON"

    "-DLLVM_BINUTILS_INCDIR=${libbfd.dev}/include"
  ];

  postInstall = ''
      ln -sv $out/bin/clang $out/bin/cpp
  '';

  passthru = {
    isClang = true;
    llvm = self;
    #inherit llvm;
  } // stdenv.lib.optionalAttrs (stdenv.targetPlatform.isLinux || (stdenv.cc.isGNU && stdenv.cc.cc ? gcc)) {
    # lol :(
    gcc = if stdenv.cc.isGNU then stdenv.cc.cc else stdenv.cc.cc.gcc;
  };
}; in self
