{ stdenv, fetchFromGitHub, cmake, pkgconfig, qt4 ? null
, withQt5 ? false, qtbase ? null, qttools ? null
, darwin ? null
, withLibsecret ? false, libsecret
}:

let useLibsecret = !stdenv.isDarwin && withLibsecret; in

assert withQt5 -> qtbase != null;
assert withQt5 -> qttools != null;
assert stdenv.isDarwin -> darwin != null;

stdenv.mkDerivation rec {
  name = "qtkeychain-${if withQt5 then "qt5" else "qt4"}-${version}";
  version = "0.10.0";            # verify after nix-build with `grep -R "set(PACKAGE_VERSION " result/`

  src = fetchFromGitHub {
    owner = "frankosterfeld";
    repo = "qtkeychain";
    rev = "v${version}";
    sha256 = "0idrcjxnxgkf3kink9w9zbbffk6lhz740f0x4vvn5yg6n9hg6q09"; # v0.9.1
  };

  cmakeFlags = [
    "-DQT_TRANSLATIONS_DIR=share/qt/translations"
    ("-DLIBSECRET_SUPPORT=" + (if useLibsecret then "ON" else "OFF"))
  ];

  nativeBuildInputs = [ cmake ]
    ++ stdenv.lib.optionals useLibsecret [ pkgconfig ] # for finding libsecret
  ;

  buildInputs = stdenv.lib.optionals useLibsecret [ libsecret ]
    ++ (if withQt5 then [ qtbase qttools ] else [ qt4 ])
    ++ stdenv.lib.optionals stdenv.isDarwin (with darwin.apple_sdk.frameworks; [
      CoreFoundation Security
    ])
  ;

  meta = {
    description = "Platform-independent Qt API for storing passwords securely";
    homepage = https://github.com/frankosterfeld/qtkeychain;
    license = stdenv.lib.licenses.bsd3;
    platforms = stdenv.lib.platforms.unix;
  };
}
