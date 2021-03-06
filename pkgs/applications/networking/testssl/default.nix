{ stdenv, fetchFromGitHub, makeWrapper, lib
, dnsutils, coreutils, openssl, inetutils, utillinux, procps
, curl, ldns, libidn2, ncurses
}:

stdenv.mkDerivation rec {
  pname = "testssl.sh";
  version = "3.0";

  src = fetchFromGitHub {
    owner = "drwetter";
    repo = pname;
    rev = version;
    sha256 = "08i1l835zlzb3qmsnsd5vhsrr82li6fnp5jqxiybbqr5wjz67ssd";
  };

  nativeBuildInputs = [ makeWrapper ];
  buildInputs = [
    coreutils # for pwd and printf
    dnsutils  # for dig
    inetutils # for hostname
    openssl   # for openssl
    procps    # for ps
    utillinux # for hexdump
    curl ldns libidn2
    ncurses   # for tput
  ];

  postPatch = ''
    substituteInPlace testssl.sh                                               \
      --replace /bin/pwd                    pwd                                \
      --replace TESTSSL_INSTALL_DIR:-\"\"   TESTSSL_INSTALL_DIR:-\"$out\"      \
      --replace PROG_NAME=\"\$\(basename\ \"\$0\"\)\" PROG_NAME=\"testssl.sh\"
  '';

  installPhase = ''
    install -D testssl.sh $out/bin/testssl.sh
    cp -r etc $out

    wrapProgram $out/bin/testssl.sh --prefix PATH ':' ${lib.makeBinPath buildInputs}
  '';

  meta = with stdenv.lib; {
    description = "CLI tool to check a server's TLS/SSL capabilities";
    longDescription = ''
      CLI tool which checks a server's service on any port for the support of
      TLS/SSL ciphers, protocols as well as recent cryptographic flaws and more.
    '';
    homepage = "https://testssl.sh/";
    license = licenses.gpl2;
    maintainers = with maintainers; [ etu ];
  };
}
