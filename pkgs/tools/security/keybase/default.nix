{ stdenv, lib, buildGoPackage, fetchFromGitHub
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
  version = "5.4.2";

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
    rev = "v${version}";
    sha256 = "08lw5aw962f75xi42bwbgba94hiql2n2jnsxrkx84czi0ijs1wlr";
  };

  nativeBuildInputs = [ makeWrapper ]; # TODO: patch paths instead?
  buildInputs = lib.optionals stdenv.isDarwin [ AVFoundation AudioToolbox ImageIO CoreMedia Foundation CoreGraphics MediaToolbox ];
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

    # Don't use debug logging as default, it's way too verbose
    substituteInPlace $bin/lib/systemd/user/keybase.service \
      --replace  " --debug" ""
    substituteInPlace $bin/lib/systemd/user/kbfs.service \
      --replace  " -debug" ""

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
    license = licenses.bsd3;
  };
}
