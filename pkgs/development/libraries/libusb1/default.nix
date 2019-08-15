{ stdenv, fetchFromGitHub, autoreconfHook, pkgconfig, systemd ? null, libobjc, IOKit, withStatic ? false }:

stdenv.mkDerivation (rec {
  pname = "libusb";
  version = "1.0.23-rc3";

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = "v${version}";
    sha256 = "0b90r5ib4fzpw69pr07zripnr2975hmfcwcz3c25f0azj335v5k0";
  };

  outputs = [ "out" "dev" ]; # get rid of propagating systemd closure

  nativeBuildInputs = [ autoreconfHook pkgconfig ];
  propagatedBuildInputs =
    stdenv.lib.optional stdenv.isLinux systemd ++
    stdenv.lib.optionals stdenv.isDarwin [ libobjc IOKit ];

  NIX_LDFLAGS = stdenv.lib.optionalString stdenv.isLinux "-lgcc_s";

  preFixup = stdenv.lib.optionalString stdenv.isLinux ''
    sed 's,-ludev,-L${systemd.lib}/lib -ludev,' -i $out/lib/libusb-1.0.la
  '';

  meta = with stdenv.lib; {
    homepage = "https://libusb.info/";
    repositories.git = "https://github.com/libusb/libusb";
    description = "cross-platform user-mode USB device library";
    longDescription = ''
      libusb is a cross-platform user-mode library that provides access to USB devices.
    '';
    platforms = platforms.all;
    license = licenses.lgpl21Plus;
    maintainers = [ ];
  };
} // stdenv.lib.optionalAttrs withStatic {
  # Carefully added here to avoid a mass rebuild.
  # Inline this the next time this package changes.
  dontDisableStatic = withStatic;
})
