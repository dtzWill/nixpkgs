{ stdenv, lib, fetchFromGitHub, cmake, libuchardet, pkgconfig
, shntool, flac, opusTools, vorbis-tools, mp3gain, lame, wavpack, vorbisgain
, gtk3
, qtbase, qttools, wrapQtAppsHook
}:

stdenv.mkDerivation rec {
  name = "flacon-${version}";
  version = "5.4.0";

  src = fetchFromGitHub {
    owner = "flacon";
    repo = "flacon";
    rev = "v${version}";
    sha256 = "1j8gzk92kn10yb7rmvrnyq0ipda2swnkmsavqsk5ws0z600p3k93";
  };

  nativeBuildInputs = [ cmake pkgconfig wrapQtAppsHook ];
  buildInputs = [ qtbase qttools libuchardet ];

  postInstall = ''
    wrapProgram $out/bin/flacon \
      --suffix XDG_DATA_DIRS : "${gtk3}/share/gsettings-schemas/${gtk3.name}" \
      --prefix PATH : "${lib.makeBinPath [ shntool flac opusTools vorbis-tools
     mp3gain lame wavpack vorbisgain ]}"
  '';

  meta = with stdenv.lib; {
    description = "Extracts audio tracks from an audio CD image to separate tracks.";
    homepage = https://flacon.github.io/;
    license = licenses.lgpl21;
    platforms = platforms.linux;
    maintainers = with maintainers; [ snglth ];
  };
}
