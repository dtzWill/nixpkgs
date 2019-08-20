
{ stdenv, fetchurl, cmake, alsaLib, atk, at-spi2-atk, at-spi2-core, cairo, cups, dbus, expat, fontconfig
, GConf, gdk-pixbuf, glib, gtk2, libX11, libxcb, libXcomposite, libXcursor
, libXdamage, libXext, libXfixes, libXi, libXrandr, libXrender, libXScrnSaver
, libXtst, nspr, nss, pango, libpulseaudio, systemd }:

let
  libPath =
    stdenv.lib.makeLibraryPath [
      alsaLib atk at-spi2-atk at-spi2-core cairo cups dbus expat fontconfig GConf gdk-pixbuf glib gtk2
      libX11 libxcb libXcomposite libXcursor libXdamage libXext libXfixes libXi
      libXrandr libXrender libXScrnSaver libXtst nspr nss pango libpulseaudio
      systemd
    ];
in
stdenv.mkDerivation rec {
  name = "cef-binary-${version}";
  #version = "3.3683.1920.g9f41a27";
  version = "74.1.13+g98f22d3+chromium-74.0.3729.108";
  src = fetchurl {
    #url = "http://opensource.spotify.com/cefbuilds/cef_binary_${version}_linux64.tar.bz2";
    # TODO: 's,+,%2B,'
    name = "${name}.tar.bz2";
    url = http://opensource.spotify.com/cefbuilds/cef_binary_74.1.13%2Bg98f22d3%2Bchromium-74.0.3729.108_linux64.tar.bz2;
    #sha256 = "12iv798p6g17jqxx4fid4jgwkrpvlfkx4250lk8byhync53zbw0d";
    sha256 = "0p0pwdk0iavc70m1wcs6g99skx4ynlndhpppbsw41ndjynw1id57";
  };
  nativeBuildInputs = [ cmake ];
  makeFlags = "libcef_dll_wrapper";
  dontStrip = true;
  dontPatchELF = true;
  installPhase = ''
    mkdir -p $out/lib/ $out/share/cef/
    cp libcef_dll_wrapper/libcef_dll_wrapper.a $out/lib/
    cp ../Release/libcef.so $out/lib/
    patchelf --set-rpath "${libPath}" $out/lib/libcef.so
    cp ../Release/*.bin $out/share/cef/
    cp -r ../Resources/* $out/share/cef/
    cp -r ../include $out/
  '';

  meta = with stdenv.lib; {
    description = "Simple framework for embedding Chromium-based browsers in other applications";
    homepage = http://opensource.spotify.com/cefbuilds/index.html;
    maintainers = with maintainers; [ puffnfresh ];
    license = licenses.bsd3;
    platforms = with platforms; linux;
  };
}
