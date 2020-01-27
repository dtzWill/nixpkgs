{ stdenv, fetchFromGitHub, fetchpatch, cmake, boost, curl, leatherman }:

stdenv.mkDerivation rec {
  name = "cpp-hocon-${version}";
  version = "0.2.1";

  src = fetchFromGitHub {
    sha256 = "0ar7q3rp46m01wvfa289bxnk9xma3ydc67by7i4nrpz8vamvhwc3";
    rev = version;
    repo = "cpp-hocon";
    owner = "puppetlabs";
  };

  patches = [
    # Add missing boost filesystem dep, fix linking
    (fetchpatch {
      url = "https://github.com/puppetlabs/cpp-hocon/commit/caab275509826dc5fe5ab2632582abb8f83ea2b3.patch";
      sha256 = "1sap2ayxjfa3rc0r1fdxw88mhkil0pxaqhzx5l6nqrr6kcbfqv9i";
    })
  ];

  NIX_CFLAGS_COMPILE = [ "-Wno-error=catch-value" ];

  nativeBuildInputs = [ cmake ];

  buildInputs = [ boost curl leatherman ];

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    inherit (src.meta) homepage;
    description = " A C++ port of the Typesafe Config library";
    license = licenses.asl20;
    maintainers = [ maintainers.womfoo ];
    platforms = platforms.linux;
  };

}
