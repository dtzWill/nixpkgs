{ stdenv, fetchFromGitHub, cmake, pkgconfig, scdoc, gnome3, gmime3, webkitgtk
, libsass, notmuch, boost, libsoup, wrapGAppsHook, glib-networking, protobuf, vim_configurable
, gtkmm3, libpeas, gsettings-desktop-schemas
, python3, python3Packages
, makeWrapper
, vim ? vim_configurable.override {
                    features = "normal";
                    gui = "auto";
                  }
}:

stdenv.mkDerivation rec {
  pname = "astroid";
  version = "0.15";

  src = fetchFromGitHub {
    owner = "astroidmail";
    repo = pname;
    rev = "v${version}";
    sha256 = "11cxbva9ni98gii59xmbxh4c6idcg3mg0pgdsp1c3j0yg7ix0lj3";
  };

  nativeBuildInputs = [ cmake pkgconfig scdoc wrapGAppsHook ];

  buildInputs = [ gnome3.gtkmm gmime3 webkitgtk libsass gnome3.libpeas
                  python3Packages.python python3Packages.pygobject3 gnome3.vte
                  notmuch boost libsoup gnome3.gsettings-desktop-schemas gnome3.defaultIconTheme
                  glib-networking protobuf ] ++ (if (!stdenv.lib.isDerivation vim)  then [] else [ vim ]);

  postPatch = ''
    sed -i "s~gvim ~${vim}/bin/vim -g ~g" src/config.cc
    sed -i "s~ -geom 10x10~~g" src/config.cc
  '';

  postInstall = ''
    wrapProgram "$out/bin/astroid" \
      --set CHARSET en_us.UTF-8 \
      --prefix PYTHONPATH : "$PYTHONPATH"
  '';

  doCheck = false; # needs X, likely works w/Xvfb if needed

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    homepage = https://astroidmail.github.io/;
    description = "GTK+ frontend to the notmuch mail system";
    maintainers = with maintainers; [ bdimcheff SuprDewd ];
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
  };
}
