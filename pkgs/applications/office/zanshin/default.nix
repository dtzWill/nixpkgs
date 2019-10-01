{
  mkDerivation, lib,
  fetchurl, fetchFromGitHub,
  extra-cmake-modules,
  qtbase, boost,
  akonadi-calendar, akonadi-notes, akonadi-search, kidentitymanagement, kontactinterface, kldap,
  krunner, kwallet, kcalcore
}:

mkDerivation rec {
  pname = "zanshin";
  #version = "0.5.0-unstable";
  #version = "0.5.71";
  version = "unstable-2019-09-29";

  #src = fetchurl {
  #  url = "https://download.kde.org/stable/${pname}/${pname}-${version}.tar.xz";
  #  sha256 = "0kyv7bmj9zv69jybdbp3n1ckmlq326bdq9rhzzcz71hifj4c1087";
  #};
  src = fetchFromGitHub {
    owner = "KDE";
    repo = pname;
    #rev = "refs/tags/${version}";
    rev = "203e6516054b1a0e2550fd3ee5d407668168992f";
    sha256 = "0h19rz9qmqva4gfpc28ps2j87vb7my3j44vi97qvcgjjp82r9m19";
  };

  patches = [ ./banner-bottom.patch ];

  postPatch = ''
    substituteInPlace CMakeLists.txt --replace "AkonadiCalendar" "AkonadiCalendar CalendarCore"
    substituteInPlace src/akonadi/akonadiserializer.cpp --replace kcalcore_version kcalendarcore_version
    substituteInPlace tests/units/akonadi/akonadiserializertest.cpp --replace kcalcore_version kcalendarcore_version
  '';

  nativeBuildInputs = [
    extra-cmake-modules
  ];

  buildInputs = [
    qtbase boost
    akonadi-calendar akonadi-notes akonadi-search kidentitymanagement kontactinterface kldap
    krunner kwallet kcalcore
  ];

  meta = with lib; {
    description = "A powerful yet simple application to manage your day to day actions, getting your mind like water";
    homepage = https://zanshin.kde.org/;
    maintainers = with maintainers; [ zraexy ];
    platforms = platforms.linux;
    license = licenses.gpl2Plus;
  };
}
