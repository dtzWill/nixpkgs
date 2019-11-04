{ mkDerivation
, lib
, fetchurl
, fetchFromGitHub
, extra-cmake-modules
, kcmutils
, kconfigwidgets
, kdbusaddons
, kdoctools
, kiconthemes
, ki18n
, knotifications
, qca-qt5
, libfakekey
, libXtst
, qtx11extras
, sshfs
, makeWrapper
, kwayland

, kirigami2
, kpeople
, krunner
, qtmultimedia
, kconfig
, kio
, kservice

# vcard
# (TODO)
, kcontacts

, pulseaudio-qt
}:

let
  kpeoplevcard = mkDerivation rec {
    pname = "kpeoplevcard";
    version = "unstable-2019-09-17";

    src = fetchFromGitHub {
      owner = "KDE";
      repo = pname;
      rev = "d91281414eb1bb45212a707af8805995cdbfd41f";
      sha256 = "1qrszxlcgz85cnasg1z9pggn8r6mhhkr03sz0r2qyiqqd23b86hv";
    };

    buildInputs = kpeople.buildInputs # O:)
    ++ [ kpeople kcontacts ];

    nativeBuildInputs = [ extra-cmake-modules kdoctools ];
  };
in
mkDerivation rec {
  pname = "kdeconnect";
  #version = "1.3.5";
  version = "unstable-2019-10-27";

  src = fetchFromGitHub {
    owner = "KDE";
    repo = "kdeconnect-kde";
    rev = "ac791640a6a96168c6ba48d0b18fc586855f6c75";
    sha256 = "0jc42vi57dxz2grfj1wlmxr4zc89chxpg0rm14vj2gqb0wbvgp7j";
  };
  #src = fetchurl {
  #  url = "mirror://kde/stable/${pname}/${version}/${pname}-kde-${version}.tar.xz";
  #  sha256 = "02lr3xx5s2mgddac4n3lkgr7ppf1z5m6ajs90rjix0vs8a271kp5";
  #};

  buildInputs = [
    libfakekey libXtst
    ki18n kiconthemes kcmutils kconfigwidgets kdbusaddons knotifications
    qca-qt5 qtx11extras makeWrapper kwayland
    kirigami2 kpeople krunner qtmultimedia kconfig kio kservice
    kpeoplevcard pulseaudio-qt
  ];

  nativeBuildInputs = [ extra-cmake-modules kdoctools ];

  postPatch = ''
    substituteInPlace plugins/runcommand/CMakeLists.txt \
      --replace 'KF5::I18n' 'KF5::I18n KF5::KCMUtils'
  '';

  postInstall = ''
    wrapProgram $out/libexec/kdeconnectd --prefix PATH : ${lib.makeBinPath [ sshfs ]}
  '';

  enableParallelBuilding = true;

  meta = with lib; {
    description = "KDE Connect provides several features to integrate your phone and your computer";
    homepage    = https://community.kde.org/KDEConnect;
    license     = with licenses; [ gpl2 ];
    maintainers = with maintainers; [ fridh ];
  };
}
