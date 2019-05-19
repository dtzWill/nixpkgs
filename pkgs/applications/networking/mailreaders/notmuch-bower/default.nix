{ stdenv, fetchFromGitHub, gawk, mercury, pandoc, ncurses, gpgme }:

stdenv.mkDerivation rec {
  name = "notmuch-bower-${version}";
  version = "0.10.0.1"; # not really

  src = fetchFromGitHub {
    owner = "wangp";
    repo = "bower";
    #rev = version;
    rev = "11867c3b2f074153b5971452ce07cb59c7493770";
    sha256 = "1x6qsxry04p4bks3n6yfhpjfwv9pjckn8728zb0px2bciaccmw3y";
  };

  nativeBuildInputs = [ gawk mercury pandoc ];

  buildInputs = [ ncurses gpgme ];

  #preBuild = ''
  #  echo "MCFLAGS += --opt-space" > src/Mercury.params
  #'';
    #echo "MCFLAGS += --opt-space --parallel --stack-segments" > src/Mercury.params
  #  echo "MCFLAGS += --intermod-opt -O6 --verbose --no-libgrade --libgrade asm_fast.gc" > src/Mercury.params

  makeFlags = [ "PARALLEL=-j$(NIX_BUILD_CORES)" "bower" "man" ];

  patches = [
    ./0001-Use-some-emoticons-for-status.patch
    ./0002-Good-signature.patch
    ./0003-tick-for-selected.patch
    ./0004-convert-inbox-tag-to-single-char-indicator-hide-impo.patch
    ./0005-hide-more-tags-that-would-be-painful-to-mass-change.patch
    ./0006-lists.patch
    ./0007-tweak-icons-fix-spacing.patch

    ./0001-hack-replace-tabs-with-spaces-in-Subject-header.patch
    ./cal.patch
  ];

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
