{ mkDerivation, lib, fetchFromGitHub, pkgconfig, qtbase, qmake, libssh }:

mkDerivation rec {
  pname = "qjournalctl";
  version = "0.6";

  src = fetchFromGitHub {
    owner = "pentix";
    repo = pname;
    rev = "refs/tags/v${version}";
    sha256 = "0vkknha6sidaqbxkx7nx7xkk0lfry1fmnwv0v9n1g2w8dvlazxwp";
  };

  postPatch = ''
    substituteInPlace qjournalctl.pro --replace /usr/ $out/
  '';

  nativeBuildInputs = [ qmake pkgconfig ];
  buildInputs = [ qtbase libssh ];

  meta = with lib; {
    description = "Qt-based Graphical User Interface for systemd's journalctl command";
    homepage = https://github.com/pentix/qjournalctl;
    license = licenses.gpl3;
    maintainers = with maintainers; [ dtzWill ];
    platforms = platforms.all;
  };
}
