{ stdenv, fetchurl, rustPlatform, darwin, openssl, libsodium, nettle, clang, libclang, pkgconfig }:

rustPlatform.buildRustPackage rec {
  pname = "pijul";
  version = "0.12.2";

  src = fetchurl {
    # url = "https://pijul.org/releases/${name}.tar.gz";
    name = "${pname}-${version}.tar.gz";
    url = "https://crates.io/api/v1/crates/${pname}/${version}/download";
    sha256 = "12aqpfd2si70qbvfnn9kvznxyd5g5gsb1kk1q52wm077cd03yapr";
  };

  nativeBuildInputs = [ pkgconfig clang ];

  cargoPatches = [ ./add-Cargo.lock.patch ];

  postInstall = ''
    mkdir -p $out/share/{bash-completion/completions,zsh/site-functions,fish/vendor_completions.d}
    $out/bin/pijul generate-completions --bash > $out/share/bash-completion/completions/pijul
    $out/bin/pijul generate-completions --zsh > $out/share/zsh/site-functions/_pijul
    $out/bin/pijul generate-completions --fish > $out/share/fish/vendor_completions.d/pijul.fish
  '';

  LIBCLANG_PATH = libclang + "/lib";

  buildInputs = [ openssl libsodium nettle libclang ] ++ stdenv.lib.optionals stdenv.isDarwin
    (with darwin.apple_sdk.frameworks; [ CoreServices Security ]);

  doCheck = false;

  cargoSha256 = "1m733gf9iyfcp3ssfsxcik6z5r1dyv6hk8mn564apfj60cbjv5vv";

  meta = with stdenv.lib; {
    description = "A distributed version control system";
    homepage = https://pijul.org;
    license = with licenses; [ gpl2Plus ];
    maintainers = [ maintainers.gal_bolle ];
    platforms = platforms.all;
  };
}
