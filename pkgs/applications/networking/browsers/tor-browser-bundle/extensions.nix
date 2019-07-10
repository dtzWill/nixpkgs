{ stdenv
, fetchgit
, fetchurl

# common
, zip

# HTTPS Everywhere
, git
, libxml2 # xmllint
, libxslt
, python36
, rsync
, which
, xxd
, utillinux # getopt
, openssl
}:

{
  https-everywhere = stdenv.mkDerivation rec {
    name = "https-everywhere-${version}";
    version = "2019.1.31";

    extid = "https-everywhere-eff@eff.org";

    src = fetchgit {
      url = "https://git.torproject.org/https-everywhere.git";
      rev = "refs/tags/${version}";
      sha256 = "04gj4farjvwwp1i507iwk70my805xjzrn7a21cdbyh04dzdxjwgk";
      fetchSubmodules = true; # for translations, TODO: remove
      leaveDotGit = true;
    };

    nativeBuildInputs = [
      git
      libxml2 # xmllint
      libxslt
      (python36.withPackages (p: [ p.lxml ]))
      rsync
      which
      xxd
      utillinux
      openssl
      zip
    ];

    buildPhase = ''
      patchShebangs utils/create_zip.py
      BRANCH="${version}" \
      $shell ./make.sh \
        --remove-update-channel
    ''; # --remove-extension-update ?

    installPhase = ''
      install -m 444 -D pkg/https-everywhere-$version-eff.xpi "$out/$extid.xpi"
    '';
  };

  noscript = stdenv.mkDerivation rec {
    name = "noscript-${version}";
    version = "10.6.1";

    extid = "{73a6fe31-595d-460b-a920-fcc0f8843232}";

    src = fetchurl {
      url = "https://secure.informaction.com/download/releases/noscript-${version}.xpi";
      sha256 = "09wprm8ca81b0b4g9j3crasmf0l0hvdlni0y5s5z44jx0k84fl5i";
    };

    dontUnpack = true;

    installPhase = ''
      install -m 444 -D $src "$out/$extid.xpi"
    '';
  };

  torbutton = stdenv.mkDerivation rec {
    name = "torbutton-${version}";
    version = "2.1.6";

    extid = "torbutton@torproject.org";

    src = fetchgit {
      url = "https://git.torproject.org/torbutton.git";
      rev = "refs/tags/${version}";
      sha256 = "10x75hxjwi386lciizins3issr5mw0hqxyb954hzlf1i4s081j7x";
    };

    nativeBuildInputs = [ zip ];

    buildPhase = ''
      $shell ./makexpi.sh
    '';

    installPhase = ''
      install -m 444 -D pkg/torbutton-$version.xpi "$out/$extid.xpi"
    '';
  };

  tor-launcher = stdenv.mkDerivation rec {
    name = "tor-launcher-${version}";
    version = "0.2.18.2";

    extid = "tor-launcher@torproject.org";

    src = fetchgit {
      url = "https://git.torproject.org/tor-launcher.git";
      rev = "refs/tags/${version}";
      sha256 = "0bzfsfgp5g192h0rjkf3z27b6ybsvlhpal8dyi8fk4kmn81fgnr2";
    };

    nativeBuildInputs = [ zip ];

    buildPhase = ''
      make package
    '';

    installPhase = ''
      install -m 444 -D pkg/tor-launcher-$version.xpi "$out/$extid.xpi"
    '';
  };
}
