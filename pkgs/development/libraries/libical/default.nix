{ stdenv, fetchFromGitHub, perl, pkgconfig, cmake, ninja, vala, gobject-introspection
, python3, tzdata, glib, libxml2, icu }:

stdenv.mkDerivation rec {
  pname = "libical";
  version = "3.0.6";

  outputs = [ "out" "dev" ]; #"devdoc" ];

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = "v${version}";
    sha256 = "181lf07fj36fp0rbcjjmb53yzdvv9i4qxpnbpax8hayjhha8pjh3";
  };

  nativeBuildInputs = [
    perl pkgconfig cmake ninja vala gobject-introspection
    (python3.withPackages (pkgs: with pkgs; [ pygobject3 ])) # running libical-glib tests
# Docs building fails: https://github.com/NixOS/nixpkgs/pull/61657#issuecomment-495579489
#    gtk-doc docbook_xsl docbook_xml_dtd_43 # docs
  ];
  buildInputs = [ glib libxml2 icu ];

  cmakeFlags = [
    "-DGOBJECT_INTROSPECTION=True"
    "-DICAL_GLIB_VAPI=True"
    "-DENABLE_GTK_DOC=OFF"
  ];

  patches = [
    # TODO: upstream this patch
    # https://github.com/libical/libical/issues/350
    ./respect-env-tzdir.patch
  ];

  # Using install check so we do not have to manually set
  # LD_LIBRARY_PATH and GI_TYPELIB_PATH variables
  doInstallCheck = true;
  enableParallelChecking = false;
  installCheckPhase = ''
    runHook preInstallCheck

    export TZDIR=${tzdata}/share/zoneinfo
    ctest --output-on-failure

    runHook postInstallCheck
  '';

  meta = with stdenv.lib; {
    homepage = https://github.com/libical/libical;
    description = "An Open Source implementation of the iCalendar protocols";
    license = licenses.mpl20;
    platforms = platforms.unix;
  };
}
