{ stdenv, lib, fetchFromGitHub, autoreconfHook, makeWrapper, pkgconfig
, zlib, lzma, bzip2, mtools, dosfstools, zip, unzip, libconfuse, libsodium
, libarchive, darwin, coreutils }:

stdenv.mkDerivation rec {
  name = "fwup-${version}";
  version = "1.4.0";

  src = fetchFromGitHub {
    owner = "fhunleth";
    repo = "fwup";
    rev = "v${version}";
    sha256 = "0hg8652k68vc0bgknc0xihfwpzwknd4vcg6lkv2xmyimqffsk0ys";
  };

  doCheck = true;
  patches = lib.optional stdenv.isDarwin [ ./fix-testrunner-darwin.patch ];

  nativeBuildInputs = [ pkgconfig autoreconfHook makeWrapper ];
  buildInputs = [ zlib lzma bzip2 libconfuse libsodium libarchive ]
    ++ lib.optionals stdenv.isDarwin [
      darwin.apple_sdk.frameworks.DiskArbitration
    ];
  propagatedBuildInputs = [ zip unzip mtools dosfstools coreutils ];

  meta = with stdenv.lib; {
    description = "Configurable embedded Linux firmware update creator and runner";
    homepage = https://github.com/fhunleth/fwup;
    license = licenses.asl20;
    maintainers = [ maintainers.georgewhewell ];
    platforms = platforms.all;
  };
}
