{ stdenv, fetchFromGitHub, makeWrapper, ruby }:

stdenv.mkDerivation rec {
  pname = "h";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "zimbatm";
    repo = "h";
    rev = "v${version}";
    hash = "sha256-chGrMtvLyyNtlM7PO1olVdkzkvMOk6OibHw+mqwVxIM=";
  };

  buildInputs = [ ruby ];

  installPhase = ''
    install -Dm755 -t $out/bin h up
  '';

  meta = with stdenv.lib; {
    description = "faster shell navigation of projects";
    homepage = "https://github.com/zimbatm/h";
    license = licenses.mit;
    maintainers = [ maintainers.zimbatm ];
  };
}
