{
  mkDerivation,
  extra-cmake-modules, gettext, kdoctools, python,
  kcoreaddons, knotifications, kwayland, kwidgetsaddons, kwindowsystem,
  cups, pcre, pipewire, kio, epoxy
}:

mkDerivation {
  name = "xdg-desktop-portal-kde";
  nativeBuildInputs = [ extra-cmake-modules gettext kdoctools python ];
  buildInputs = [
    cups pcre pipewire kio epoxy
    kcoreaddons knotifications kwayland kwidgetsaddons kwindowsystem
  ];
}
