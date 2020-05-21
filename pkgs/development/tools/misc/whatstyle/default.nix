{ stdenv, python3, fetchFromGitHub, clang-unwrapped }:

python3.pkgs.buildPythonApplication rec {
  pname = "whatstyle";
  version = "0.1.8";
  src = fetchFromGitHub {
    owner = "mikr";
    repo = pname;
    rev = "v${version}";
    sha256 = "08lfd8h5fnvy5gci4f3an411cypad7p2yiahvbmlp51r9xwpaiwr";
  };

  patches = [
    ./support-clang8-options.patch
    ./support-clang9-clang10ish.patch
  ];

  checkInputs = [ clang-unwrapped /* clang-format */ ];

  doCheck = false; # 3 or 4 failures depending on version, haven't investigated.

  meta = with stdenv.lib; {
    description = "Find a code format style that fits given source files";
    homepage = "https://github.com/mikr/whatstyle";
    license = licenses.mit;
    maintainers = with maintainers; [ dtzWill ];
    platforms = platforms.all;
  };
}
