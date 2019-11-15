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
  version = "unstable-2019-10-26";

  #src = fetchurl {
  #  url = "https://download.kde.org/stable/${pname}/${pname}-${version}.tar.xz";
  #  sha256 = "0kyv7bmj9zv69jybdbp3n1ckmlq326bdq9rhzzcz71hifj4c1087";
  #};
  src = fetchFromGitHub {
    owner = "KDE";
    repo = pname;
    #rev = "refs/tags/${version}";
    rev = "13f9a9aaa33e13f885ee073a61e2d53d861db90c";
    sha256 = "1cjfdsxqivk20dm1v3pcmk3c8xkjis729qyhm2qdp4w1xzm9pk6i";
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
