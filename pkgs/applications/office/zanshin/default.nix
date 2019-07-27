{
  mkDerivation, lib,
  fetchurl, fetchFromGitHub,
  extra-cmake-modules,
  qtbase, boost,
  akonadi-calendar, akonadi-notes, akonadi-search, kidentitymanagement, kontactinterface, kldap,
  krunner, kwallet
}:

mkDerivation rec {
  pname = "zanshin";
  version = "0.5.0-unstable";

  #src = fetchurl {
  #  url = "https://download.kde.org/stable/${pname}/${pname}-${version}.tar.xz";
  #  sha256 = "0kyv7bmj9zv69jybdbp3n1ckmlq326bdq9rhzzcz71hifj4c1087";
  #};
  src = fetchFromGitHub {
    owner = "KDE";
    repo = pname;
    rev = "08dbd232d7ade7bfa9f256446e98385d9e29f1c4";
    sha256 = "1l7i0n8bcd0a1z9rr97328zwkb2d8rjh245733x2sa8masnwz957";
  };

  patches = [ ./banner-bottom.patch ];

  nativeBuildInputs = [
    extra-cmake-modules
  ];

  buildInputs = [
    qtbase boost
    akonadi-calendar akonadi-notes akonadi-search kidentitymanagement kontactinterface kldap
    krunner kwallet
  ];

  meta = with lib; {
    description = "A powerful yet simple application to manage your day to day actions, getting your mind like water";
    homepage = https://zanshin.kde.org/;
    maintainers = with maintainers; [ zraexy ];
    platforms = platforms.linux;
    license = licenses.gpl2Plus;
  };
}
