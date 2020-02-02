{ stdenv, fetchFromGitHub, buildGoModule }:

buildGoModule rec {
  pname = "cheat";
  version = "3.4.1";

  src = fetchFromGitHub {
    owner = "cheat";
    repo = "cheat";
    rev = version;
    sha256 = "07pi1pfy8nk5bc4xhq0xq4nr456r5609i0mxg55q4kxy1530infd";
  };

  subPackages = [ "cmd/cheat" ];

  modSha256 = "0d4rk5zfhl4zf5n8f5k6kyk3yn5vdbb7hz3wgk8cfygwrbmblkc4";

  meta = with stdenv.lib; {
    description = "Create and view interactive cheatsheets on the command-line";
    maintainers = with maintainers; [ mic92 ];
    license = with licenses; [ gpl3 mit ];
    homepage = "https://github.com/cheat/cheat";
  };
}
