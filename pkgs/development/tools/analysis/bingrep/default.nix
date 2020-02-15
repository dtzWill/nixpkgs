{ stdenv, rustPlatform, fetchFromGitHub }:

rustPlatform.buildRustPackage rec {
  pname = "bingrep";
  version = "0.8.2";

  src = fetchFromGitHub {
    owner = "m4b";
    repo = pname;
    rev = "v${version}";
    sha256 = "1qv41g7mblnq07145m03s2fhbrjfsc0924zb9z4cp159ygkggxcy";
  };

  cargoSha256 = "1a8davsj49zs36i6igdd4i2sck5z8zfvbldamxvjlwh34y4gjqp9";

  meta = with stdenv.lib; {
    description = "Greps through binaries from various OSs and architectures, and colors them";
    homepage = "https://github.com/m4b/bingrep";
    license = licenses.mit;
    maintainers = with maintainers; [ minijackson ];
  };
}
