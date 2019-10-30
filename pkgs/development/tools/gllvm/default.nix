{ stdenv, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  pname = "gllvm";
  version = "1.2.5";

  goPackagePath = "github.com/SRI-CSL/gllvm";

  src = fetchFromGitHub {
    owner = "SRI-CSL";
    repo = pname;
    rev = "v${version}";
    sha256 = "0sq9p4fi3qjaf6irjmm99zif831ccypmrp18qs33pm8y5kjm3x0x";
  };

  meta = with stdenv.lib; {
    homepage = https://github.com/SRI-CSL/gllvm;
    description = "Whole Program LLVM: wllvm ported to go";
    license = licenses.bsd3;
    maintainers = with maintainers; [ dtzWill ];
    platforms = platforms.all;
  };
}
