{ stdenv
, fetchFromGitHub
, fetchpatch
, fetchzip
, lib
, callPackage
, openssl
, cmake
, autoconf
, automake
, libtool
, pkgconfig
, bison
, flex
, groff
, perl
, python3
, time
, upx
, ncurses
, libffi
, libxml2
, zlib
, withPEPatterns ? false
}:

let
  capstone = fetchFromGitHub {
    owner = "avast-tl";
    repo = "capstone";
    rev = "27c713fe4f6eaf9721785932d850b6291a6073fe";
    sha256 = "105z1g9q7s6n15qpln9vzhlij7vj6cyc5dqdr05n7wzjvlagwgxc";
  };
  elfio = fetchFromGitHub {
    owner = "avast-tl";
    repo = "elfio";
    rev = "f85f07390b756fee61408dfe0b04ae4fb86c5477";
    sha256 = "1ncx97zwf5lrvx3py4cpyqjzddr3bqjb7ywm9i35hv6mlvpy2hzc";
  };
  keystone = fetchFromGitHub { # only for tests
    owner = "keystone-engine";
    repo = "keystone";
    rev = "d7ba8e378e5284e6384fc9ecd660ed5f6532e922";
    sha256 = "1yzw3v8xvxh1rysh97y0i8y9svzbglx2zbsqjhrfx18vngh0x58f";
  };
  libdwarf = fetchFromGitHub {
    owner = "avast-tl";
    repo = "libdwarf";
    rev = "85465d5e235cc2d2f90d04016d6aca1a452d0e73";
    sha256 = "11y62r65py8yp57i57a4cymxispimn62by9z4j2g19hngrpsgbki";
  };
  llvm = fetchFromGitHub {
    owner = "avast-tl";
    repo = "llvm";
    rev = "3d1e5d0bc1122a027e83f57c86851a027dd09112";
    sha256 = "0d5r7575lh494qb13pnydf40i4dkc3znwvcr4rncxlyl0iz6p3h4";
  };
  pelib = fetchFromGitHub {
    owner = "avast-tl";
    repo = "pelib";
    rev = "10bd64227023a2a37f075db3de9f4626dfbfb2b9";
    sha256 = "167yj7jgv63k093l9wjck6wg6s6dl4vx1lk7nahkq2sv7h24s9pk";
  };
  rapidjson = fetchFromGitHub {
    owner = "Tencent";
    repo = "rapidjson";
    rev = "v1.1.0";
    sha256 = "1jixgb8w97l9gdh3inihz7avz7i770gy2j2irvvlyrq3wi41f5ab";
  };
  yaracpp = callPackage ./yaracpp.nix {}; # is its own package because it needs a patch
  yaramod = fetchFromGitHub {
    owner = "avast-tl";
    repo = "yaramod";
    rev = "v2.4.1";
    sha256 = "0lzcwzb77kqvvyama0bcl4zcwzs3la7313gi04243gw4spn9piwf";
  };
  jsoncpp = fetchFromGitHub {
    owner = "open-source-parsers";
    repo = "jsoncpp";
    rev = "1.8.4";
    sha256 = "1z0gj7a6jypkijmpknis04qybs1hkd04d1arr3gy89lnxmp6qzlm";
  };
  googletest = fetchFromGitHub { # only for tests
    owner = "google";
    repo = "googletest";
    rev = "83fa0cb17dad47a1d905526dcdddb5b96ed189d2";
    sha256 = "1c2r0p9v7vz2vasy8bknfb448l6wsvzw35s8hmc5z013z5502mpk";
  };
  tinyxml2 = fetchFromGitHub {
    owner = "leethomason";
    repo = "tinyxml2";
    rev = "cc1745b552dd12bb1297a99f82044f83b06729e0";
    sha256 = "015g8520a0c55gwmv7pfdsgfz2rpdmh3d1nq5n9bd65n35492s3q";
  };

  retdec-support = let
    version = "2019-03-08"; # make sure to adjust both hashes (once with withPEPatterns=true and once withPEPatterns=false)
  in fetchzip {
    url = "https://github.com/avast-tl/retdec-support/releases/download/${version}/retdec-support_${version}.tar.xz";
    sha256 = if withPEPatterns then "10w4k9pmsvj3fjsaz5hwwcwlhl5ccw6jbfdknmqgjnybqzh72nxp"
                               else "06rgxhnbgfs7f518xrgi5rhw46fvg31zmkx8p0qbn4yk2npqv9x5";
    stripRoot = false;
    # Removing PE signatures reduces this from 3.8GB -> 642MB (uncompressed)
    extraPostFetch = lib.optionalString (!withPEPatterns) ''
      rm -r "$out/generic/yara_patterns/static-code/pe"
    '';
  } // {
    inherit version; # necessary to check the version against the expected version
  };

  # patch CMakeLists.txt for a dependency and compare the versions to the ones expected by upstream
  # this has to be applied for every dependency (which it is in postPatch)
  patchDep = dep: ''
    # check if our version of dep is the same version that upstream expects
    echo "Checking version of ${dep.dep_name}"
    expected_rev="$( sed -n -e 's|.*URL https://github.com/.*/archive/\(.*\)\.zip.*|\1|p' "deps/${dep.dep_name}/CMakeLists.txt" )"
    if [ "$expected_rev" != '${dep.rev}' ]; then
      echo "The ${dep.dep_name} dependency has the wrong version: ${dep.rev} while $expected_rev is expected."
      exit 1
    fi

    # patch the CMakeLists.txt file to use our local copy of the dependency instead of fetching it at build time
    sed -i -e 's|URL .*|URL ${dep}|' "deps/${dep.dep_name}/CMakeLists.txt"
  '';

in stdenv.mkDerivation rec {
  pname = "retdec";

  # If you update this you will also need to adjust the versions of the updated dependencies. You can do this by first just updating retdec
  # itself and trying to build it. The build should fail and tell you which dependencies you have to upgrade to which versions.
  # I've notified upstream about this problem here:
  # https://github.com/avast-tl/retdec/issues/412
  version = "3.3";

  src = fetchFromGitHub {
    owner = "avast-tl";
    repo = pname;
    name = "retdec-${version}";
    rev = "refs/tags/v${version}";
    sha256 = "1qsyrjksjrxqx4hvshhi3gsrcg6pj1417rdl2mp4n690w59xz55i";
  };

  nativeBuildInputs = [
    cmake
    autoconf
    automake
    libtool
    pkgconfig
    bison
    flex
    groff
    perl
    python3
  ];

  buildInputs = [
    openssl
    ncurses
    libffi
    libxml2
    zlib
  ];

  cmakeFlags = [
    "-DRETDEC_TESTS=ON" # build tests
  ];

  # all dependencies that are normally fetched during build time (the subdirectories of `deps`)
  # all of these need to be fetched through nix and the CMakeLists files need to be patched not to fetch them themselves
  external_deps = [
    (capstone // { dep_name = "capstone"; })
    (elfio // { dep_name = "elfio"; })
    (googletest // { dep_name = "googletest"; })
    (jsoncpp // { dep_name = "jsoncpp"; })
    (keystone // { dep_name = "keystone"; })
    (libdwarf // { dep_name = "libdwarf"; })
    (llvm // { dep_name = "llvm"; })
    (pelib // { dep_name = "pelib"; })
    (rapidjson // { dep_name = "rapidjson"; })
    (tinyxml2 // { dep_name = "tinyxml2"; })
    (yaracpp // { dep_name = "yaracpp"; })
    (yaramod // { dep_name = "yaramod"; })
  ];

  postPatch = (lib.concatMapStrings patchDep external_deps) + ''
    # install retdec-support
    echo "Checking version of retdec-support"
    find .
    expected_version="$( sed -n -e "s|^version = '\(.*\)'$|\1|p" 'support/install-share.py' )"
    if [ "$expected_version" != '${retdec-support.version}' ]; then
      echo "The retdec-support dependency has the wrong version: ${retdec-support.version} while $expected_version is expected."
      exit 1
    fi
    mkdir -p "$out/share/retdec"
    cp -r ${retdec-support} "$out/share/retdec/support" # write permission needed during install
    chmod -R u+w "$out/share/retdec/support"
    # python file originally responsible for fetching the retdec-support archive to $out/share/retdec
    # that is not necessary anymore, so empty the file
    echo > support/install-share.py

    # call correct `time` and `upx` programs
    substituteInPlace scripts/retdec-config.py --replace /usr/bin/time ${time}/bin/time
    substituteInPlace scripts/retdec-unpacker.py --replace "'upx'" "'${upx}/bin/upx'"
  '';

  enableParallelBuilding = true;

  doInstallCheck = true;
  installCheckPhase = ''
    ${python3.interpreter} "$out/bin/retdec-tests-runner.py"

    rm -rf $out/bin/__pycache__
  '';

  meta = with lib; {
    description = "A retargetable machine-code decompiler based on LLVM";
    homepage = https://retdec.com;
    license = licenses.mit;
    maintainers = with maintainers; [ dtzWill timokau ];
    platforms = ["x86_64-linux" "i686-linux"];
  };
}
