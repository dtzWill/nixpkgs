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
  rev = "64ba06dc32ea56b183da7dae9feb727552af531e"; # 2019-12-20
  sha256 = "0qs2lfhydd9xmwdpqi60b14kvp8wwyazd415p1ic18jha62bcxsa";
};
pstore_src = fetchFromGitHub {
  owner = "SNSystems";
  name = "pstore";
  repo = "pstore";
  #rev = "llvmorg-8.0.0";
  rev = "609a33722f2b8e9e06c661746ab734f3f5eaa311"; # 2019-12-30";
  sha256 = "11z0cqg86gx76s4ppq3ly5n5d0jhnnl47s23js9d5sb3mylpyrfp";
};
self = stdenv.mkDerivation rec {
  pname = "llvm-project-prepo";
  #version = "8.0.0";
  version = "2019-12-30";

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
