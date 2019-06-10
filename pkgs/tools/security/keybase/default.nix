{ stdenv, lib, buildGoPackage, fetchurl, fetchFromGitHub, cf-private
, AVFoundation, AudioToolbox, ImageIO, CoreMedia
, Foundation, CoreGraphics, MediaToolbox
, fuse, lsof, coreutils, utillinux, procps
, gnupg, gconf, gtk2, dbus
, sysctl, getent, systemd, pinentry
, libsecret, git, iproute, iputils
, makeWrapper
}:

buildGoPackage rec {
  pname = "keybase";
  version = "4.0.0-2019-06-04";
  #version = "4.0.0";

  goPackagePath = "github.com/keybase/client";
  subPackages = [
    "go/keybase"
    "go/kbnm"
    "go/kbfs/kbfsfuse"
    "go/kbfs/kbfsgit/git-remote-keybase"
    #"go/kbfs/redirector"

    "go/kbfs/kbfstool"
    #"go/tools/systemd"
    #"go/tools/sigchain"
    "go/kbfs/kbpagesconfig"
    "go/kbfs/kbpagesd"
  ];

  dontRenameImports = true;

  src = fetchFromGitHub {
    owner = "keybase";
    repo = "client";
    rev = "0ba4b678810e3eaa89cb5070a156484329a2491a";
    sha256 = "12aybjgg902v09i924x99bw5nd6gc3011h5lk4q6vnlmk1qvja8r";
  };
  #src = fetchurl {
  #  url = "https://github.com/keybase/client/archive/v${version}.tar.gz";
  #  sha256 = "14c0876mxz3xa2k4d665kf8j6k3hc6qybkj0gr4pr9c9gs70cgjh";
  #};

  nativeBuildInputs = [ makeWrapper ]; # TODO: patch paths instead?

  buildInputs = lib.optionals stdenv.isDarwin [
    AVFoundation AudioToolbox ImageIO CoreMedia Foundation CoreGraphics MediaToolbox
    # Needed for OBJC_CLASS_$_NSData symbols.
    cf-private
  ];
  buildFlags = [ "-tags production" "-buildmode pie" ];

  postInstall = lib.optionalString stdenv.hostPlatform.isLinux ''
    install -Dm644 \
      -t $bin/lib/systemd/user \
      $NIX_BUILD_TOP/go/src/${goPackagePath}/packaging/linux/systemd/{kbfs,keybase,keybase.gui}.service

    substituteInPlace $bin/lib/systemd/user/kbfs.service \
      --replace fusermount /run/wrappers/bin/fusermount \
      --replace /usr/bin $bin/bin \
      --replace "(keybase " "($bin/bin/keybase " \
      --replace " keybase-redirector.service" ""

    # I'm sorry for this...
    # It was already bad and now it's worse. :(
    # Let env var override the path used for unmount attempts,
    # so as to match kbfsfuse's behavior re:determining path.
    substituteInPlace $bin/lib/systemd/user/kbfs.service \
      --replace "\$($bin/bin/keybase config get -d -b mountdir)" \
                "\''${KEYBASE_MOUNTDIR:-\$($bin/bin/keybase config get -d -b mountdir)}"

    substituteInPlace $bin/lib/systemd/user/keybase.service \
      --replace /usr/bin $bin/bin

    # Drop this, until we build GUI here too
    rm $bin/lib/systemd/user/keybase.gui.service

    # XXX: actually it's easier to just emit our own
    # rm $bin/lib -rf

    for x in $bin/bin/*; do
      wrapProgram $x \
        --prefix PATH : /run/wrappers/bin:${lib.makeBinPath [ lsof /* for good measure (and 'kill'): */ coreutils utillinux procps gnupg gconf gtk2 dbus sysctl getent systemd pinentry git iproute iputils ]} \
        --prefix LD_LIBRARY_PATH : ${stdenv.lib.makeLibraryPath [ libsecret gtk2 gconf ]}
    done
  '';

  meta = with lib; {
    homepage = https://www.keybase.io/;
    description = "The Keybase official command-line utility and service.";
    platforms = platforms.linux ++ platforms.darwin;
    maintainers = with maintainers; [ carlsverre np rvolosatovs ];
  };
}
