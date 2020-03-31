{ stdenv, fetchFromGitHub, qtbase
, qtdeclarative, cmake, texlive, ninja }:

stdenv.mkDerivation rec {
  pname = "dwarf-therapist";
  version = "41.1.5";

  src = fetchFromGitHub {
    owner = "Dwarf-Therapist";
    repo = "Dwarf-Therapist";
    rev = "v${version}";
    sha256 = "0w1mwwf49vdmvmdfvlkn4m0hzvlj111rpl8hv4rw6v8nv6yfb2y4";
  };

  buildInputs = [ qtbase qtdeclarative ];
  nativeBuildInputs = [ texlive cmake ninja ];

  installPhase = if stdenv.isDarwin then ''
    mkdir -p $out/Applications
    cp -r DwarfTherapist.app $out/Applications
  '' else null;

  meta = with stdenv.lib; {
    description = "Tool to manage dwarves in a running game of Dwarf Fortress";
    maintainers = with maintainers; [ the-kenny abbradar bendlas numinit ];
    license = licenses.mit;
    platforms = platforms.unix;
    homepage = https://github.com/Dwarf-Therapist/Dwarf-Therapist;
  };
}
