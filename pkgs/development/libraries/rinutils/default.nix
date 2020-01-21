{ stdenv, fetchFromGitHub, fetchurl, cmake, perl, pkgconfig, cmocka }:

let
  shlomif_common_cmake = fetchurl {
    url = "https://raw.githubusercontent.com/shlomif/shlomif-cmake-modules/master/shlomif-cmake-modules/Shlomif_Common.cmake";
    sha256 = "05xdikw5ln0yh8p5chsmd8qnndmxg5b5vjlfpdqrjcb1ncqzywkc";
  };
  p = perl.withPackages(ps: with ps; [
    Carp DataDumper EnvPath FilePath Inline InlineC
    ListMoreUtils PathTiny
    TestDifferences TestMore TestTrailingSpace StringShellQuote
  ]);
in
 stdenv.mkDerivation rec {
  pname = "rinutils";
  version = "0.2.0";

  src = fetchFromGitHub {
    owner = "shlomif";
    repo = pname;
    rev = version;
    sha256 = "1fpxyg86ggv0h7j8aarjjxrvwlj7jycd3bw066c0dwkq2fszxsf2";
  };

  postPatch = ''
    ln -s ${shlomif_common_cmake} cmake/Shlomif_Common.cmake

    patchShebangs run-tests.pl
  '';

  nativeBuildInputs = [ cmake p pkgconfig ];

  checkInputs = [ cmocka ];

  doCheck = true;

  meta = with stdenv.lib; {
    description = "C11 / gnu11 utilities C library";
    homepage = "https://github.com/shlomif/rinutils";
    license = licenses.mit;
    maintainers = with maintainers; [ dtzWill ];
  };
}
