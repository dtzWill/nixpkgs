{ stdenv
, cmake
, coreutils
, glibc
, which
, perl
, libedit
, ninja
, pkgconfig
, sqlite
, swig
, bash
, libxml2
, clang
, python
, ncurses
, libuuid
, libbsd
, icu
, autoconf
, libtool
, automake
, libblocksruntime
, curl
, rsync
, git
, libgit2
, fetchFromGitHub
, findutils
, makeWrapper
, gnumake
, file
}:

let
  v_base = "5.1.1";
  version = "${v_base}-RELEASE";
  version_friendly = "${v_base}";

  tag = "refs/tags/swift-${version}";
  fetch = { repo, sha256, fetchSubmodules ? false }:
    fetchFromGitHub {
      owner = "apple";
      inherit repo sha256 fetchSubmodules;
      rev = tag;
      name = "${repo}-${version}-src";
    };

  sources = {
    clang = fetch {
      repo = "swift-clang";
      sha256 = "0n7k6nvzgqp6h6bfqcmna484w90db3zv4sh5rdh89wxyhdz6rk4v";
    };
    clang-tools-extra = fetch {
      repo = "swift-clang-tools-extra";
      sha256 = "0snp2rpd60z239pr7fxpkj332rkdjhg63adqvqdkjsbrxcqqcgqa";
    };
    llvm = fetch {
      repo = "swift-llvm";
      sha256 = "00ldd9dby6fl6nk3z17148fvb7g9x4jkn1afx26y51v8rwgm1i7f";
    };
    compilerrt = fetch {
      repo = "swift-compiler-rt";
      sha256 = "1431f74l0n2dxn728qp65nc6hivx88fax1wzfrnrv19y77br05wj";
    };
    cmark = fetch {
      repo = "swift-cmark";
      sha256 = "079smm79hbwr06bvghd2sb86b8gpkprnzlyj9kh95jy38xhlhdnj";
    };
    lldb = fetch {
      repo = "swift-lldb";
      sha256 = "0j787475f0nlmvxqblkhn3yrvn9qhcb2jcijwijxwq95ar2jdygs";
    };
    llbuild = fetch {
      repo = "swift-llbuild";
      sha256 = "1n2s5isxyl6b6ya617gdzjbw68shbvd52vsfqc1256rk4g448v8b";
    };
    pm = fetch {
      repo = "swift-package-manager";
      sha256 = "1a49jmag5mpld9zr96g8a773334mrz1c4nyw38gf4p6sckf4jp29";
    };
    xctest = fetch {
      repo = "swift-corelibs-xctest";
      sha256 = "0rxy9sq7i0s0kxfkz0hvdp8zyb40h31f7g4m0kry36qk82gzzh89";
    };
    foundation = fetch {
      repo = "swift-corelibs-foundation";
      sha256 = "1iiiijsnys0r3hjcj1jlkn3yszzi7hwb2041cnm5z306nl9sybzp";
    };
    libdispatch = fetch {
      repo = "swift-corelibs-libdispatch";
      sha256 = "0laqsizsikyjhrzn0rghvxd8afg4yav7cbghvnf7ywk9wc6kpkmn";
      fetchSubmodules = true;
    };
    swift = fetch {
      repo = "swift";
      sha256 = "0m4r1gzrnn0s1c7haqq9dlmvpqxbgbkbdfmq6qaph869wcmvdkvy";
    };
    libcxx = fetch {
      repo = "swift-libcxx";
      sha256 = "01q6m13cqa7d74l2sbci90rwk34ysjn81zb9ikfq8qnhh85rd6vv";
    };
    # These likely can be added, however they require a working toolchain
    # which is what we're primarily creating here.
    # If build turnaround for this all was faster i'd try accomplishing that
    # at the end... instead it may be easier to have these as separate expressions
    # and hope they work just as well as if they were included originally.
    sourcekit-lsp = fetch {
      repo = "sourcekit-lsp";
      sha256 = "0k84ssr1k7grbvpk81rr21ii8csnixn9dp0cga98h6i1gshn8ml4";
    };
    indexstore-db = fetch {
      repo = "indexstore-db";
      sha256 = "1gwkqkdmpd5hn7555dpdkys0z50yh00hjry2886h6rx7avh5p05n";
    };
  };

  devInputs = [
    curl
    glibc
    icu
    libblocksruntime
    libbsd
    libedit
    libuuid
    libxml2
    ncurses
    sqlite
    swig
  ];

  cmakeFlags = [
    "-DGLIBC_INCLUDE_PATH=${stdenv.cc.libc.dev}/include"
    "-DC_INCLUDE_DIRS=${stdenv.lib.makeSearchPathOutput "dev" "include" devInputs}:${libxml2.dev}/include/libxml2"
    "-DGCC_INSTALL_PREFIX=${clang.cc.gcc}"
  ];

  builder = ''
    # gcc-6.4.0/include/c++/6.4.0/cstdlib:75:15: fatal error: 'stdlib.h' file not found
    NIX_CFLAGS_COMPILE="$( echo ${clang.default_cxx_stdlib_compile} ) $NIX_CFLAGS_COMPILE"
    # During the Swift build, a full local LLVM build is performed and the resulting clang is invoked.
    # This compiler is not using the Nix wrappers, so it needs some help to find things.
    export NIX_LDFLAGS_BEFORE="-rpath ${clang.cc.gcc.lib}/lib -L${clang.cc.gcc.lib}/lib $NIX_LDFLAGS_BEFORE"

    $SWIFT_SOURCE_ROOT/swift/utils/build-script \
      --preset=buildbot_linux \
      installable_package=$INSTALLABLE_PACKAGE \
      install_prefix=$out \
      install_destdir=$SWIFT_INSTALL_DIR \
      extra_cmake_options="${stdenv.lib.concatStringsSep "," cmakeFlags}"'';

in
stdenv.mkDerivation rec {
  pname = "swift";
  version = version_friendly;

  nativeBuildInputs = [
    autoconf
    automake
    bash
    cmake
    coreutils
    findutils
    gnumake
    libtool
    makeWrapper
    ninja
    perl
    pkgconfig
    python
    rsync
    which
  ];
  buildInputs = devInputs ++ [
    clang
  ];

  # TODO: Revisit what's propagated and how
  propagatedBuildInputs = [
    libgit2
    python
  ];
  propagatedUserEnvPkgs = [ git pkgconfig ];

  hardeningDisable = [ "format" ]; # for LLDB

  configurePhase = ''
    cd ..

    export INSTALLABLE_PACKAGE=$PWD/swift.tar.gz

    mkdir build install
    export SWIFT_BUILD_ROOT=$PWD/build
    export SWIFT_INSTALL_DIR=$PWD/install

    cd $SWIFT_BUILD_ROOT

    unset CC
    unset CXX

    export NIX_ENFORCE_PURITY=
  '';

  unpackPhase = ''
    mkdir src
    cd src
    export sourceRoot=$PWD
    export SWIFT_SOURCE_ROOT=$PWD

    cp -r ${sources.clang} clang
    cp -r ${sources.clang-tools-extra} clang-tools-extra
    cp -r ${sources.llvm} llvm
    cp -r ${sources.compilerrt} compiler-rt
    cp -r ${sources.cmark} cmark
    cp -r ${sources.lldb} lldb
    cp -r ${sources.llbuild} llbuild
    cp -r ${sources.pm} swiftpm
    cp -r ${sources.xctest} swift-corelibs-xctest
    cp -r ${sources.foundation} swift-corelibs-foundation
    cp -r ${sources.libdispatch} swift-corelibs-libdispatch
    cp -r ${sources.swift} swift
    cp -r ${sources.libcxx} libcxx
    cp -r ${sources.sourcekit-lsp} sourcekit-lsp
    cp -r ${sources.indexstore-db} indexstore-db

    chmod -R u+w .
  '';

  patchPhase = ''
    # Just patch all the things for now, we can focus this later
    patchShebangs $SWIFT_SOURCE_ROOT

    # TODO eliminate use of env.
    find -type f -print0 | xargs -0 sed -i \
      -e 's|/usr/bin/env|${coreutils}/bin/env|g' \
      -e 's|/usr/bin/make|${gnumake}/bin/make|g' \
      -e 's|/bin/mkdir|${coreutils}/bin/mkdir|g' \
      -e 's|/bin/cp|${coreutils}/bin/cp|g' \
      -e 's|/usr/bin/file|${file}/bin/file|g'

    substituteInPlace swift/stdlib/public/Platform/CMakeLists.txt \
      --replace '/usr/include' "${stdenv.cc.libc.dev}/include"
    substituteInPlace swift/utils/build-script-impl \
      --replace '/usr/include/c++' "${clang.cc.gcc}/include/c++"
    patch -p1 -d swift -i ${./patches/glibc-arch-headers.patch}
    patch -p1 -d swift -i ${./patches/nothing-too-fancy-yet.patch}
    patch -p1 -d swift -i ${./patches/0001-build-presets-linux-don-t-require-using-Ninja.patch}
    patch -p1 -d swift -i ${./patches/0002-build-presets-linux-allow-custom-install-prefix.patch}
    patch -p1 -d swift -i ${./patches/0003-build-presets-linux-don-t-build-extra-libs.patch}
    patch -p1 -d swift -i ${./patches/0004-build-presets-linux-plumb-extra-cmake-options.patch}

    sed -i swift/utils/build-presets.ini \
      -e 's/^test-installable-package$/# \0/' \
      -e 's/^test$/# \0/' \
      -e 's/^validation-test$/# \0/' \
      -e 's/^long-test$/# \0/' \
      -e 's/^stress-test$/# \0/' \
      -e 's/^test-optimized$/# \0/' \
      \
      -e 's/^swift-install-components=autolink.*$/\0;editor-integration/'

    substituteInPlace clang/lib/Driver/ToolChains/Linux.cpp \
      --replace 'SysRoot + "/usr/lib' '"${glibc}/lib" "'
    patch -p1 -d clang -i ${./patches/llvm-include-dirs.patch}
    patch -p1 -d clang -i ${./purity.patch}

    # Workaround hardcoded dep on "libcurses" (vs "libncurses"):
    sed -i 's,curses,ncurses,' llbuild/*/*/CMakeLists.txt

    PREFIX=''${out/#\/}
    substituteInPlace swift-corelibs-xctest/build_script.py \
      --replace usr "$PREFIX"

    substituteInPlace indexstore-db/Utilities/build-script-helper.py \
      --replace "'usr'" "'$PREFIX'"
  '';

  buildPhase = builder;

  doCheck = false;

  checkInputs = [ file ];

  # TODO: investigate the non-working tests
  checkPhase = ''
    checkTarget=check-swift-all
    ninjaFlags='-C buildbot_linux/swift-${stdenv.hostPlatform.parsed.kernel.name}-${stdenv.hostPlatform.parsed.cpu.name}'

    ninjaCheckPhase
  '';

  installPhase = ''
    mkdir -p $out

    # Extract the generated tarball into the store
    PREFIX=''${out/#\/}
    tar xf $INSTALLABLE_PACKAGE -C $out --strip-components=3 $PREFIX
    find $out -type d -empty -delete

    wrapProgram $out/bin/swift \
      --suffix C_INCLUDE_PATH : $out/lib/swift/clang/include \
      --suffix CPLUS_INCLUDE_PATH : $out/lib/swift/clang/include \
      --suffix LIBRARY_PATH : $icu/lib
  '';

  # Hack to avoid TMPDIR in RPATHs.
  preFixup = ''rm -rf "$(pwd)" '';

  meta = with stdenv.lib; {
    description = "The Swift Programming Language";
    homepage = https://github.com/apple/swift;
    maintainers = with maintainers; [ dtzWill ];
    license = licenses.asl20;
    # Swift doesn't support 32bit Linux, unknown on other platforms.
    platforms = platforms.linux;
    badPlatforms = platforms.i686;
    broken = stdenv.isAarch64; # 2018-09-04, never built on Hydra
  };
  passthru = { inherit sources; };
}
