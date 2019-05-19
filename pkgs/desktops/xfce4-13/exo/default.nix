{ mkXfceDerivation, docbook_xsl, libxslt, perlPackages, gtk2, gtk3
, libxfce4ui, libxfce4util }:

mkXfceDerivation rec {
  category = "xfce";
  pname = "exo";
  version = "0.12.5";

  sha256 = "1gf9fb48nkafb4jj0hmm2s00mpl32dp5iqxfaxm5i1nc6884hipw";

  nativeBuildInputs = [ libxslt perlPackages.URI ];
  buildInputs = [ gtk2 gtk3 libxfce4ui libxfce4util ];

  postPatch = ''
    substituteInPlace docs/reference/Makefile.am \
      --replace http://docbook.sourceforge.net/release/xsl/current \
                ${docbook_xsl}/share/xml/docbook-xsl
  '';

  meta = {
    description = "Application library for Xfce";
  };
}
