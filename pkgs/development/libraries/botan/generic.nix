{ stdenv, fetchurl, python, doxygen
, boost, bzip2, gmp, openssl, lzma, sqlite, zlib
# Passed by version specific builders
, baseVersion, revision, sha256, ext
, extraConfigureFlags ? ""
, postPatch ? null
, darwin
, patches ? []
, ...
}:

stdenv.mkDerivation rec {
  pname = "botan";
  version = "${baseVersion}.${revision}";

  src = fetchurl {
    name = "Botan-${version}.${ext}";
    url = "http://botan.randombit.net/releases/Botan-${version}.${ext}";
    inherit sha256;
  };
  inherit patches;
  inherit postPatch;

  nativeBuildInputs = [ python /* configure */ doxygen ];
  buildInputs = [ python bzip2 zlib gmp openssl lzma boost sqlite ]
             ++ stdenv.lib.optional stdenv.isDarwin darwin.apple_sdk.frameworks.Security;

  preConfigure = ''
    patchShebangs configure.py
  '';
  configureScript = "./configure.py";
  configureFlags = [
    "--prefix=${placeholder "out"}"
    "--with-bzip2"
    "--with-openssl"
    "--with-zlib"
  ] ++ extraConfigureFlags
  ++ stdenv.lib.optional (doxygen != null) "--with-doxygen"
  ++ stdenv.lib.optional stdenv.cc.isClang "--cc=clang";

  enableParallelBuilding = true;

  preInstall = ''
    if [ -d src/scripts ]; then
      patchShebangs src/scripts
    fi
  '';

  postInstall = ''
    cd "$out"/lib/pkgconfig
    ln -s botan-*.pc botan.pc || true
  '';

  meta = with stdenv.lib; {
    inherit version;
    description = "Cryptographic algorithms library";
    maintainers = with maintainers; [ raskin ];
    platforms = ["x86_64-linux" "i686-linux" "x86_64-darwin"];
    license = licenses.bsd2;
  };
  passthru.updateInfo.downloadPage = "http://files.randombit.net/botan/";
}
