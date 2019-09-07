{ stdenv, fetchFromGitHub
, cmake
}:

stdenv.mkDerivation rec {
  name = "intel-gmmlib-${version}";
  version = "19.2.4";

  src = fetchFromGitHub {
    owner  = "intel";
    repo   = "gmmlib";
    rev    = name;
    sha256 = "184jwksm6sdfgs6ynn0ls919a3qj1hnzdgvlkri9mfzlzfkzlxw0";
  };

  nativeBuildInputs = [ cmake ];

  meta = with stdenv.lib; {
    homepage = https://github.com/intel/gmmlib;
    license = licenses.mit;
    description = "Intel Graphics Memory Management Library";
    platforms = [ "x86_64-linux" ];
    maintainers = with maintainers; [ jfrankenau ];
  };
}
