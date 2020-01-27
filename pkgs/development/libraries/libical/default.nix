{ stdenv, fetchFromGitHub, perl, pkgconfig, cmake, ninja, vala, gobject-introspection
, python3, tzdata, glib, libxml2, icu }:

stdenv.mkDerivation rec {
  pname = "libical";
  version = "3.0.8";

  outputs = [ "out" "dev" ]; #"devdoc" ];

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    #rev = "v${version}";
    rev = "2faf08be22990876303e098795423960191498ac";
    sha256 = "0kzhhym1206ks92gpz3y4ayxi7bkbbhqnic1lh2yxabdqdjrq0d6";
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
    # https://github.com/libical/libical/issues/350
    # Upstream merged fix for respecting TZDIR (in 2018),
    # but only in master branch not the 3.0 branch releases are cut from.
    # This patch also makes libical check /etc/zoneinfo first,
    # so keep that but drop the rest once this reaches a release.
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
