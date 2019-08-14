{
  mkDerivation, lib, config,

  extra-cmake-modules, kdoctools,

  breeze-icons, karchive, kconfig, kcrash, kdbusaddons, ki18n,
  kiconthemes, kitemmodels, khtml, kio, kparts, kpty, kservice, kwidgetsaddons,

  libarchive, libzip,

  # Archive tools
  p7zip, lrzip,

  # Unfree tools
  unfreeEnableUnrar ? false, unrar,

  fetchpatch
}:

let
  extraTools = [ p7zip lrzip ] ++ lib.optional unfreeEnableUnrar unrar;
in

mkDerivation {
  name = "ark";
  meta = {
    license = with lib.licenses;
      [ gpl2 lgpl3 ] ++ lib.optional unfreeEnableUnrar unfree;
    maintainers = [ lib.maintainers.ttuegel ];
  };

  outputs = [ "out" "dev" ];
  nativeBuildInputs = [ extra-cmake-modules kdoctools ];
  buildInputs = [ libarchive libzip ] ++ extraTools;
  propagatedBuildInputs = [
    breeze-icons karchive kconfig kcrash kdbusaddons khtml ki18n kiconthemes kio
    kitemmodels kparts kpty kservice kwidgetsaddons
  ];

  # Add missing include, fix build
  patches = [ (fetchpatch {
    url = "https://phabricator.kde.org/D22461?download=true";
    sha256 = "0sipw5z60gk6l025rk4xsbc10n3bvv9743f4cbvf6hyy4mbm4p1m";
  }) ];

  qtWrapperArgs = [ "--prefix" "PATH" ":" (lib.makeBinPath extraTools) ];
}
