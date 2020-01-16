{ stdenv, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  pname = "elfinfo";
  version = "1.0.0";

  goPackagePath = "github.com/xyproto/elfinfo";
  src = fetchFromGitHub {
    rev = version;
    owner = "xyproto";
    repo = "elfinfo";
    sha256 = "0cfyb10f7ndwgwgkxjv287m9lpw06ywrijz0sngd624cc6llcs96";
  };

  meta = with stdenv.lib; {
    description = "Small utility for showing information about ELF files";
    homepage = https://elfinfo.roboticoverlords.org/;
    license = licenses.mit;
    maintainers = with maintainers; [ dtzWill ];
  };
}
