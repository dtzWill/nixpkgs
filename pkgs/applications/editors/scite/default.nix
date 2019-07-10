{ stdenv, fetchurl, pkgconfig, lua, glib, gtk3, wrapGAppsHook }:

stdenv.mkDerivation rec {
  pname = "scite";
  version = "4.1.7";

  src = fetchurl {
    url = "https://www.scintilla.org/scite${builtins.replaceStrings ["."][""] version}.tgz";
    sha256 = "15jchd9hgwnyf536vkp5qp23ascj42d0zc1xapgl0r052p3a9h4g";
  };

  nativeBuildInputs = [ pkgconfig wrapGAppsHook ];
  buildInputs = [ glib gtk3 lua ];

  sourceRoot = "scite/gtk";

  makeFlags = [ "gnomeprefix=${placeholder "out"}" "prefix=${placeholder "out"}" "DESTDIR=" "GTK3=1" ];
  buildPhase = ''
    make -C ../../scintilla/gtk $makeFlags -j
    make $makeFlags -j
  '';

  postInstall = "ln -sr $out/bin/SciTE $out/bin/scite";

  meta = with stdenv.lib; {
    homepage = https://www.scintilla.org/SciTE.html;
    description = "SCIntilla based Text Editor";
    license = licenses.mit;
    platforms = platforms.linux;
    maintainers = [ maintainers.rszibele ];
  };
}
