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
  version = "0.5.71";

  #src = fetchurl {
  #  url = "https://download.kde.org/stable/${pname}/${pname}-${version}.tar.xz";
  #  sha256 = "0kyv7bmj9zv69jybdbp3n1ckmlq326bdq9rhzzcz71hifj4c1087";
  #};
  src = fetchFromGitHub {
    owner = "KDE";
    repo = pname;
    rev = "refs/tags/${version}";
    #rev = "074d2c34883a7136ce07138dd0de62a370936f9e";
    sha256 = "0vphriqf1w8k21q6skw7w7i129ab3z9a3m8l9xsm527spw2rwk55";
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
