{ stdenv, fetchurl, meson, ninja, gettext, appstream-glib, gnome3 }:

let
  pname = "cantarell-fonts";
  version = "0.201";
in stdenv.mkDerivation rec {
  name = "${pname}-${version}";

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${stdenv.lib.versions.majorMinor version}/${name}.tar.xz";
    sha256 = "0qwqmkczqy09fdj8l11nr841ks0dwsydqg55qyms12m4yvjn87xn";
  };

  nativeBuildInputs = [ meson ninja gettext appstream-glib ];

  # ad-hoc fix for https://github.com/NixOS/nixpkgs/issues/50855
  # until we fix gettext's envHook
  preBuild = ''
    export GETTEXTDATADIRS="$GETTEXTDATADIRS_FOR_BUILD"
  '';

  outputHashAlgo = "sha256";
  outputHashMode = "recursive";
  outputHash = "0xf24y9ywvygi584cpmj1wbd3i2p70p6gld0j75bknp2djn9wwk8";

  passthru = {
    updateScript = gnome3.updateScript {
      packageName = pname;
    };
  };

  meta = {
    description = "Default typeface used in the user interface of GNOME since version 3.0";
    platforms = stdenv.lib.platforms.all;
    license = stdenv.lib.licenses.ofl;
    maintainers = with stdenv.lib.maintainers; [ ];
  };
}
