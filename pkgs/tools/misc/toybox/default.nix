{
  stdenv, lib, fetchFromGitHub, which,
  enableStatic ? false,
  enableMinimal ? false,
  extraConfig ? ""
}:

stdenv.mkDerivation rec {
  name = "${pname}-${version}";
  pname = "toybox";
  version = "0.8.1";

  src = fetchFromGitHub {
    owner = "landley";
    repo = pname;
    rev = version;
    sha256 = "0mi1glrqmri3v6imbf8k20ylf0kmpv9prbnbggmcqfa0pswpyl4v";
  };

  buildInputs = lib.optionals enableStatic [ stdenv.cc.libc stdenv.cc.libc.static ];

  postPatch = "patchShebangs .";

  inherit extraConfig;
  passAsFile = [ "extraConfig" ];

  configurePhase = ''
    make ${if enableMinimal then
      "allnoconfig"
    else
      if stdenv.isFreeBSD then
        "freebsd_defconfig"
      else
        if stdenv.isDarwin then
          "macos_defconfig"
        else
          "defconfig"
    }

    cat $extraConfigPath .config > .config-
    mv .config- .config

    make oldconfig
  '';

  makeFlags = [ "PREFIX=${placeholder "out"}/bin" ]
    ++ lib.optional enableStatic "LDFLAGS=--static";

  installTargets = "install_flat";

  doCheck = true;
  checkInputs = [ which ]; # used for tests with checkFlags = [ "DEBUG=true" ];
  checkTarget = "tests";

  NIX_CFLAGS_COMPILE = [ "-Wno-error" ];

  meta = with stdenv.lib; {
    description = "Lightweight implementation of some Unix command line utilities";
    homepage = https://landley.net/toybox/;
    license = licenses.bsd0;
    platforms = with platforms; linux ++ darwin ++ freebsd;
    maintainers = with maintainers; [ hhm ];
    priority = 10;
  };
}
