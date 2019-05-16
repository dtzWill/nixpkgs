{
  mkDerivation, lib, fetchurl, # fetchgit, fetchpatch,
  extra-cmake-modules, kdoctools, wrapGAppsHook,
  kcrash, kconfig, kinit, kparts
}:

mkDerivation rec {
  pname = "kdiff3";
  version = "1.8";

  src = fetchurl {
    url = "https://download.kde.org/stable/${pname}/${pname}-${version}.tar.xz";
    sha256 = "083pz5c1w7l9h4sb8zz8a763yph5sk3mxnhpdykz1rrggy9f8p54";
  };

  patches = [
    # TODO: is this still relevant?
    #(fetchpatch {
    #  name = "git-mergetool.diff"; # see https://gitlab.com/tfischer/kdiff3/merge_requests/2
    #  url = "https://gitlab.com/vcunat/kdiff3/commit/6106126216.patch";
    #  sha256 = "16xqc24y8bg8gzkdbwapiwi68rzqnkpz4hgn586mi01ngig2fd7y";
    #})
  ];
  #patchFlags = "-p 2";

  #postPatch = ''
  #  sed -re "s/(p\\[[^]]+] *== *)('([^']|\\\\')+')/\\1QChar(\\2)/g" -i src/diff.cpp
  #'';

  nativeBuildInputs = [ extra-cmake-modules kdoctools wrapGAppsHook ];

  propagatedBuildInputs = [ kconfig kcrash kinit kparts ];

  meta = with lib; {
    homepage = http://kdiff3.sourceforge.net/;
    license = licenses.gpl2Plus;
    description = "Compares and merges 2 or 3 files or directories";
    maintainers = with maintainers; [ peterhoeg ];
    platforms = with platforms; linux;
  };
}
