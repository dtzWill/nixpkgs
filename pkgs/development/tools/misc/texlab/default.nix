{ stdenv
, rustPlatform
, fetchFromGitHub
, nodejs
, Security
}:

rustPlatform.buildRustPackage rec {
  pname = "texlab";
  version = "1.9.0-git";

  src = fetchFromGitHub {
    owner = "latex-lsp";
    repo = pname;
    rev = "3eb23a66541e3660c59728fe8f99c4c85b094cc2";
    sha256 = "1bbq0q23byyrs0knhrsg6l2r0gpflkbwfr43cq7d4ccrz6051bnz";
  };

  cargoSha256 = "1lpp1lhkcy3garvqjx2s1fhaanxv2gvjbqc5c88p85xb299w1ds8";

  buildInputs = stdenv.lib.optionals stdenv.isDarwin [ Security ];

  meta = with stdenv.lib; {
    description = "An implementation of the Language Server Protocol for LaTeX";
    homepage = https://texlab.netlify.com/;
    license = licenses.mit;
    maintainers = with maintainers; [ doronbehar metadark ];
    platforms = platforms.all;
  };
}
