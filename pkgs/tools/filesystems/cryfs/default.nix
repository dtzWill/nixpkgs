{ stdenv, fetchFromGitHub
, cmake, pkgconfig, coreutils
, boost, cryptopp, curl, fuse, openssl, python, spdlog
}:

stdenv.mkDerivation rec {
  name = "cryfs-${version}";
  version = "0.10.2";

  src = fetchFromGitHub {
    owner  = "cryfs";
    repo   = "cryfs";
    rev    = "${version}";
    sha256 = "1mi6lf8k4bknxjf11a2vqsrgyx3ld8fbsqssvs91dlmwcpm9qi1i";
  };

  prePatch = ''
    patchShebangs src
  '';

  buildInputs = [ boost cryptopp curl fuse openssl python spdlog ];

  patches = [
    ./test-no-network.patch  # Disable tests using external networking
  ];

  # coreutils is needed for the vendored scrypt
  nativeBuildInputs = [ cmake coreutils pkgconfig ];

  enableParallelBuilding = true;

  cmakeFlags = [
    "-DCRYFS_UPDATE_CHECKS=OFF"
    "-DBoost_USE_STATIC_LIBS=OFF" # this option is case sensitive
  ];

  doCheck = true;

  # Cryfs tests are broken on darwin
  checkPhase = stdenv.lib.optionalString (!stdenv.isDarwin) ''
    # Skip CMakeFiles directory and tests depending on fuse (does not work well with sandboxing)
    SKIP_IMPURE_TESTS="CMakeFiles|fspp|cryfs-cli"

    for test in `ls -d test/*/ | egrep -v "$SKIP_IMPURE_TESTS"`; do
      "./$test`basename $test`-test"
    done
  '';

  installPhase = ''
    # Building with BUILD_TESTING=ON is missing the install target
    mkdir -p $out/bin
    install -m 755 ./src/cryfs-cli/cryfs $out/bin/cryfs
  '';

  meta = with stdenv.lib; {
    description = "Cryptographic filesystem for the cloud";
    homepage    = https://www.cryfs.org;
    license     = licenses.lgpl3;
    maintainers = with maintainers; [ peterhoeg ];
    platforms   = with platforms; linux;
  };
}
