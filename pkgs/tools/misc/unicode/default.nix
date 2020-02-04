{ stdenv, fetchFromGitHub, fetchurl, python3Packages }:

python3Packages.buildPythonApplication rec {
  pname = "unicode";
  version = "2.7";

  src = fetchFromGitHub {
    owner = "garabik";
    repo = "unicode";
    rev = "v${version}";
    sha256 = "15d9yvarxsiy0whx1mxzsjnnkrjdm3ga4qv2yy398mk0jh763q9v";
  };

  ucdtxt = fetchurl {
    url = http://www.unicode.org/Public/12.1.0/ucd/UnicodeData.txt;
    sha256 = "0dn91zw7107dp9b5pclqiyjcv9sin7m7gbjh7d351m6riz6imawk";
  };

  postFixup = ''
    substituteInPlace "$out/bin/.unicode-wrapped" \
      --replace "/usr/share/unicode/UnicodeData.txt" "$ucdtxt"
  '';

  meta = with stdenv.lib; {
    description = "Display unicode character properties";
    homepage = https://github.com/garabik/unicode;
    license = licenses.gpl3;
    maintainers = [ maintainers.woffs ];
    platforms = platforms.all;
  };
}
