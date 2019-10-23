{ buildGoModule
, fetchFromGitHub
, lib
}:

buildGoModule rec {
  pname = "packr";
  version = "2.7.1";

  src = fetchFromGitHub {
    owner = "gobuffalo";
    repo = pname;
    rev = "v${version}";
    sha256 = "0m5kl2fq8gf1v4vllgag2xl8fd382sdgqrcdb8f5alsnrdn08kb9";
  };

  modSha256 = "086gydrl3i35hawb5m7rsb4a0llcpdpgid1xfw2z9n6jkwkclw4n";

  meta = with lib; {
    description = "The simple and easy way to embed static files into Go binaries";
    homepage = "https://github.com/gobuffalo/packr";
    license = licenses.mit;
    maintainers = with maintainers; [ mmahut ];
  };
}
