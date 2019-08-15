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
  version = "0.5.0-unstable";

  #src = fetchurl {
  #  url = "https://download.kde.org/stable/${pname}/${pname}-${version}.tar.xz";
  #  sha256 = "0kyv7bmj9zv69jybdbp3n1ckmlq326bdq9rhzzcz71hifj4c1087";
  #};
  src = fetchFromGitHub {
    owner = "KDE";
    repo = pname;
    rev = "97eda12069f428e3067ec9efe3e6a42b661b24b2";
    sha256 = "0jcvjapcx63n0psh3br3sly5lf4al02hlsqaqk8xs785ivmz25bi";
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
