{ stdenv, lib, fetchFromGitHub, autoreconfHook, pkgconfig
, libXext, libdrm, libXfixes, wayland, libffi, libX11
, libGL, mesa
, minimal ? false, libva-minimal
}:

stdenv.mkDerivation rec {
  name = "libva-${lib.optionalString minimal "minimal-"}${version}";
  version = if minimal then "2.6.0.pre1" else "2.7.0";

  # update libva-utils and vaapiIntel as well
  src = fetchFromGitHub {
    owner  = "01org";
    repo   = "libva";
    rev    = version;
    sha256 = if minimal then "1vlvk0wyzrj2qnvkzafs78164z5dmblcw8in6wd5w9b20g62vhp5" else "0i9i9xnivii920jrcd9x34y8d245qrj5x3nbqkzkllr8zjx20vxs";
  };

  outputs = [ "dev" "out" ];

  nativeBuildInputs = [ autoreconfHook pkgconfig ];

  buildInputs = [ libdrm ]
    ++ lib.optionals (!minimal) [ libva-minimal libX11 libXext libXfixes wayland libffi libGL ];
  # TODO: share libs between minimal and !minimal - perhaps just symlink them

  enableParallelBuilding = true;

  configureFlags = [
    # Add FHS paths for non-NixOS applications.
    "--with-drivers-path=${mesa.drivers.driverLink}/lib/dri:/usr/lib/dri:/usr/lib32/dri"
  ] ++ lib.optionals (!minimal) [ "--enable-glx" ];

  installFlags = [
    "dummy_drv_video_ladir=$(out)/lib/dri"
  ];

  meta = with stdenv.lib; {
    description = "VAAPI library: Video Acceleration API";
    homepage = http://www.freedesktop.org/wiki/Software/vaapi;
    license = licenses.mit;
    maintainers = with maintainers; [ ];
    platforms = platforms.unix;
  };
}
