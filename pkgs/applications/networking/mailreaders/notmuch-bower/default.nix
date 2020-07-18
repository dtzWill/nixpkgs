{ stdenv, fetchFromGitHub, gawk, mercury, pandoc, ncurses, gpgme, utillinuxMinimal }:

stdenv.mkDerivation rec {
  name = "notmuch-bower-${version}";
  version = "0.11.0.3"; # not really

  # Temporarily use fork until I can cleanup patch/merge mashup
  src = fetchFromGitHub {
    #owner = "wangp";
    owner = "dtzWill";
    repo = "bower";
    #rev = version;
    rev = "2b153041b7e96ac312d518e5d47c3a3d14a69d27";
    sha256 = "17qci4zj2cm3q7gfdj5sbydx1wfqpb9h912a3y40893gk84q9saz";
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
