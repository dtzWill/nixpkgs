{ stdenv, fetchFromGitHub, buildPerlPackage, shortenPerlShebang, LWP, LWPProtocolHttps, DataDump, JSON }:

buildPerlPackage rec {
  pname = "WWW-YoutubeViewer";
  version = "3.7.2";

  src = fetchFromGitHub {
    owner  = "trizen";
    repo   = "youtube-viewer";
    rev    = version;
    sha256 = "07rs0c2zjj41haaiy7jzz10n0h48pkpl6knxyp0x2993kggk121r";
  };

  nativeBuildInputs = stdenv.lib.optional stdenv.isDarwin shortenPerlShebang;
  propagatedBuildInputs = [
    LWP
    LWPProtocolHttps
    DataDump
    JSON
  ];
  postInstall = stdenv.lib.optionalString stdenv.isDarwin ''
    shortenPerlShebang $out/bin/youtube-viewer
  '';

  meta = {
    description = "A lightweight application for searching and streaming videos from YouTube";
    homepage = https://github.com/trizen/youtube-viewer;
    maintainers = with stdenv.lib.maintainers; [ woffs ];
    license = with stdenv.lib.licenses; [ artistic2 ];
  };
}
