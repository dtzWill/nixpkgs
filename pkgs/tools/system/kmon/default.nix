{ stdenv, fetchFromGitHub, rustPlatform, python3, libxcb }:

rustPlatform.buildRustPackage rec {
  pname = "kmon";
  version = "1.0.1";

  src = fetchFromGitHub {
    owner = "orhun";
    repo = pname;
    rev = "v${version}";
    sha256 = "0kmkcs13cccmjjfbl25bs3m54zcjcs38fiv84q0vy09a4dnx3gn8";
  };

  # XXX: legacy hash for now
  #cargoSha256 = "0l1yq9k6lyk0ww1nzk93axylgrwipkmmqh9r6fq4a31wjlblrkkb";
  cargoSha256 = "0gj0a4xa0pmfs4f625564cf6v4mx19ndz1lh60v7d3kkaw7abj5c";

  nativeBuildInputs = [ python3 ];

  buildInputs = [ libxcb ];

  postInstall = ''
    install -D man/kmon.8 -t $out/share/man/man8/
  '';

  meta = with stdenv.lib; {
    description = "Linux Kernel Manager and Activity Monitor";
    homepage = "https://github.com/orhun/kmon";
    license = with licenses; [ gpl3 ];
    platforms = platforms.linux;
    maintainers = with maintainers; [ misuzu ];
  };
}
