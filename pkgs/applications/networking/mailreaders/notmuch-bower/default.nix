{ stdenv, fetchFromGitHub, gawk, mercury, pandoc, ncurses, gpgme, utillinuxMinimal }:

stdenv.mkDerivation rec {
  name = "notmuch-bower-${version}";
  version = "0.11.0.1"; # not really

  # Temporarily use fork until I can cleanup patch/merge mashup
  src = fetchFromGitHub {
    #owner = "wangp";
    owner = "dtzWill";
    repo = "bower";
    #rev = version;
    rev = "6c594fa352b9c3ee2e799b0008cbf433a9698acd";
    sha256 = "0yvw4js8sc2v0443fdcm4wl63fm5hnxg8gl9wllpnwrfqlmx0nc1";
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
