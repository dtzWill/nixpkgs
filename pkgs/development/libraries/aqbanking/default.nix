{ stdenv, fetchurl, fetchFromGitHub, gmp, gwenhywfar, libtool, libxml2, libxslt
, autoreconfHook, pkgconfig, gettext, xmlsec, zlib
}:

let
  inherit ((import ./sources.nix).aqbanking) sha256 version;
in stdenv.mkDerivation rec {
  pname = "aqbanking";
  inherit version;

  # XXX: unofficial (afaiK), but aquamaniac.de has been down for some time now...
  src = fetchFromGitHub {
    owner = "aqbanking";
    repo = pname;
    rev = version;
    inherit sha256;
  };
  #src = fetchurl {
  #  url = "https://www.aquamaniac.de/rdm/attachments/download/107/aqbanking-${version}.tar.gz";
  #  sha256 = "1111111111111111111111111111111111111111111111111111";
  #};
  #  qstring = "package=03&release=${releaseId}&file=02";
  #  mkURLs = map (base: "${base}/sites/download/download.php?${qstring}");
  #in fetchurl {
  #  name = "${pname}-${version}.tar.gz";
  #  urls = mkURLs [ "http://www.aquamaniac.de" "http://www2.aquamaniac.de" ];
  #  inherit sha256;
  #};

  preConfigure = ''
    sed -i -e '/^aqbanking_plugindir=/ {
      c aqbanking_plugindir="\''${libdir}/gwenhywfar/plugins"
    }' configure
  '';

  buildInputs = [ gmp gwenhywfar libtool libxml2 libxslt xmlsec zlib ];

  nativeBuildInputs = [ autoreconfHook pkgconfig gettext ];

  configureFlags = [ "--with-gwen-dir=${gwenhywfar}" ];

  postInstall = ''
    substituteInPlace $out/lib/cmake/aqbanking-*/aqbanking-config.cmake \
      --replace "{includedir}" "{prefix}/include"
  '';

  meta = with stdenv.lib; {
    description = "An interface to banking tasks, file formats and country information";
    homepage = http://www2.aquamaniac.de/sites/download/packages.php?package=03&showall=1;
    hydraPlatforms = [];
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ goibhniu ];
    platforms = platforms.linux;
  };
}
