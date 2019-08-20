{ lib, ruby, bundlerApp }:

bundlerApp {
  pname = "3llo";
  gemdir = ./.;

  inherit ruby;

  exes = [ "3llo" ];

  meta = with lib; {
    description = "Trello interactive CLI on terminal";
    license = licenses.mit;
    homepage = https://github.com/qcam/3llo;
    maintainers = with maintainers; [ ma27 ];
  };
}
