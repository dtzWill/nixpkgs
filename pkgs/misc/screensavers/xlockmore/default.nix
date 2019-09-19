{ stdenv, lib, fetchurl, pkgconfig
, pam ? null
, libX11, libXext, libXinerama, libXdmcp, libXpm, libXt
, libGL
# , ftgl # maybe?
, libpng, freetype
}:

stdenv.mkDerivation rec {
  pname = "xlockmore";
  version = "5.58";

  src = fetchurl {
    url = "http://sillycycle.com/xlock/${pname}-${version}.tar.xz";
    sha256 = "1va11sbv5lbkxkp0i0msz5md3n2n82nzppk27rzdrw7y79vq37zw";
    curlOpts = "--user-agent 'Mozilla/5.0'";
  };

  nativeBuildInputs = [ pkgconfig ];

  # Optionally, it can use GTK+.
  buildInputs = [
    pam
    libX11 libXext libXinerama libXdmcp libXpm libXt
    libGL
    libpng freetype
  ];

  # Don't try to install `xlock' setuid. Password authentication works
  # fine via PAM without super user privileges.
  configureFlags = [
    "--disable-setuid"
    "--enable-appdefaultdir=${placeholder "out"}/share/X11/app-defaults"

    "--with-ext"
    "--with-xinerama"
    "--with-dmcp"
    "--with-xpm"
    "--with-opengl"
    "--with-mesa"
    "--with-png"
    "--with-ttf"
    "--with-freetype"

    "--without-motif"
    "--without-editres"
    "--without-magick"
    "--without-gtk"
    "--without-gtk2"
    "--without-esound"
    "--without-replay"
    "--without-nas"
    ] ++ (lib.optional (pam != null) "--enable-pam");

  ## postPatch =
  ##   let makePath = p: lib.concatMapStringsSep " " (x: x + "/" + p) buildInputs;
  ##       inputs = "${makePath "lib"} ${makePath "include"}";
  ##   in ''
  ##     sed -i 's,\(for ac_dir in\),\1 ${inputs},' configure.ac
  ##     sed -i 's,/usr/,/no-such-dir/,g' configure.ac
  ##     configureFlags+=" --enable-appdefaultdir=$out/share/X11/app-defaults"
  ##   '';

  enableParallelBuilding = true;

  hardeningDisable = [ "format" ]; # no build output otherwise

  meta = with lib; {
    description = "Screen locker for the X Window System";
    homepage = http://sillycycle.com/xlockmore.html;
    license = licenses.gpl2;
    maintainers = with maintainers; [ pSub ];
    platforms = platforms.linux;
  };
}
