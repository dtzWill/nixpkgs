{ stdenv, fetchFromGitHub, gawk, mercury, pandoc, ncurses, gpgme, utillinuxMinimal }:

stdenv.mkDerivation rec {
  name = "notmuch-bower-${version}";
  version = "0.12.0.1"; # not really

  # Temporarily use fork until I can cleanup patch/merge mashup
  src = fetchFromGitHub {
    #owner = "wangp";
    owner = "dtzWill";
    repo = "bower";
    #rev = version;
    rev = "856ef532db6fe2870725cb04846520ac005846c6";
    sha256 = "0b8h3nz09fah84sbvx2zwry746m2hgn26mrh02j07ahb056cygsx";
  };

  nativeBuildInputs = [ gawk mercury pandoc ];

  buildInputs = [ ncurses gpgme ];

  #preBuild = ''
  #  echo "MCFLAGS += --opt-space" > src/Mercury.params
  #'';
    #echo "MCFLAGS += --opt-space --parallel --stack-segments" > src/Mercury.params
  #  echo "MCFLAGS += --intermod-opt -O6 --verbose --no-libgrade --libgrade asm_fast.gc" > src/Mercury.params

  buildFlags = [ "PARALLEL=-j$(NIX_BUILD_CORES)" "bower" "man" ];

  doCheck = true;

  checkInputs = [ utillinuxMinimal /* rev */ ];

  checkPhase = ''
    make -C tests
  '';

  installPhase = ''
    mkdir -p $out/bin
    mv bower $out/bin/
    mkdir -p $out/share/man/man1
    mv bower.1 $out/share/man/man1/
  '';

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    homepage = https://github.com/wangp/bower;
    description = "A curses terminal client for the Notmuch email system";
    maintainers = with maintainers; [ erictapen ];
    license = licenses.gpl3;
    platforms = platforms.linux;
  };
}
