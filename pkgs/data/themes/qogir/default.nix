{ stdenv, fetchFromGitHub, gdk_pixbuf, librsvg, gtk-engine-murrine }:

stdenv.mkDerivation rec {
  pname = "qogir-theme";
  version = "2019-06-17";

  src = fetchFromGitHub {
    owner = "vinceliuice";
    repo = pname;
    #rev = version;
    rev = "4dc272d120491709a49c01e0e858b462eda9344d";
    sha256 = "0xkbrykfq0r86ncmq4ks5q2csaaayg0j2jz7iwfjdqzxhmxqc9js";
  };

  buildInputs = [ gdk_pixbuf librsvg ];

  propagatedUserEnvPkgs = [ gtk-engine-murrine ];

  installPhase = ''
    patchShebangs .
    mkdir -p $out/share/themes
    name= ./Install -d $out/share/themes
  '';

  meta = with stdenv.lib; {
    description = "A flat Design theme for GTK based desktop environments";
    homepage = https://vinceliuice.github.io/Qogir-theme;
    license = licenses.gpl3;
    platforms = platforms.unix;
    maintainers = [ maintainers.romildo ];
  };
}
