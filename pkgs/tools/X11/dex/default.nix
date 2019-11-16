{ stdenv, fetchFromGitHub, python3, fetchpatch }:

stdenv.mkDerivation rec {
  program = "dex";
  name = "${program}-${version}";
  version = "0.8.0";

  src = fetchFromGitHub {
    owner = "jceb";
    repo = program;
    rev = "v${version}";
    sha256 = "13dkjd1373mbvskrdrp0865llr3zvdr90sc6a6jqswh3crmgmz4k";
  };

  buildInputs = [ python3 ];
  nativeBuildInputs = [ python3.pkgs.sphinx python3.pkgs.setuptools ];
  makeFlags = [ "PREFIX=${placeholder "out"}" "VERSION=${version}" ];

  patches = [
    (fetchpatch {
      name = "fix-version-number.patch";
      url = https://github.com/jceb/dex/commit/107358ddf5e1ca4fa56ef1a7ab161dc3b6adc45a.patch;
      sha256 = "06dfkfzxp8199by0jc5wim8g8qw38j09dq9p6n9w4zaasla60pjq";
    })
    (fetchpatch {
      name = "add-term-option.patch";
      url = https://github.com/jceb/dex/commit/e183bc04f7afe719ba3fc137604f2cdf08e03c22.patch;
      sha256 = "1krzlxpy6qwh0agmxn2k2jslzs9pl2dqwg6g0ap10ryw9zxdynz5";
    })
    (fetchpatch {
      name = "add-wait-option.patch";
      url = https://github.com/jceb/dex/commit/cfbb76cd2ff32b9c821b91b5372a1770d6ac300a.patch;
      sha256 = "1ghmgzd9r1jg1hva5dxcxav9ynzsmyka3pnqndknpngkqb0vnf0s";
    })
  ];

  meta = with stdenv.lib; {
    description = "A program to generate and execute DesktopEntry files of the Application type";
    homepage = https://github.com/jceb/dex;
    platforms = platforms.linux;
    license = licenses.gpl3Plus;
  };
}
