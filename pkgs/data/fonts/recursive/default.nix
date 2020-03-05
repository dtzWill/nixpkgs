{ stdenv, fetchzip }:

stdenv.mkDerivation rec {
  pname = "recursive";
  version = "1.043";

  src = fetchzip {
    url = "https://github.com/arrowtype/recursive/releases/download/${version}/Recursive-Beta_${version}.zip";
    sha256 = "0l39wdc1ycbg0n18zin8g7spfvnd8xr8d1172h26mwfl4arxsks4";
    stripRoot = false;
  };

  installPhase = ''
    mkdir -p $out/share/fonts/{opentype,truetype,woff2}
    find -name "*.otf" -exec cp "{}" $out/share/fonts/opentype \;
    find -name "*.ttf" -exec cp "{}" $out/share/fonts/truetype \;
    find -name "*.woff2" -exec cp "{}" $out/share/fonts/woff2 \;
  '';

  meta = with stdenv.lib; {
    homepage = https://github.com/arrowtype/recursive;
    description = "A variable font family for code & UI";
    license = licenses.ofl;
    maintainers = [ maintainers.eadwu ];
    platforms = platforms.all;
  };
}
