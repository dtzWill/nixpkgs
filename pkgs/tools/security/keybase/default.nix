{ stdenv, lib, buildGoPackage, fetchurl, fetchFromGitHub, cf-private
, AVFoundation, AudioToolbox, ImageIO, CoreMedia
, Foundation, CoreGraphics, MediaToolbox
}:

buildGoPackage rec {
  pname = "keybase";
  version = "4.0.0-2019-05-20";

  goPackagePath = "github.com/keybase/client";
  subPackages = [
    "go/keybase"
    "go/kbnm"
    "go/kbfs/kbfsfuse"
    "go/kbfs/kbfsgit/git-remote-keybase"
    "go/kbfs/redirector"

    "go/kbfs/kbfstool"
    #"go/tools/systemd"
    #"go/tools/sigchain"
  ];

  dontRenameImports = true;

  src = fetchFromGitHub {
    owner = "keybase";
    repo = "client";
    rev = "bd0061d6e90c010bc13c13ad8acf4fabc0fd3b3f";
    sha256 = "1k2w1a9ifc40lkyadda8afnpci66yypnym4sxj13dp81qf8j2daa";
  };
  #src = fetchurl {
  #  url = "https://github.com/keybase/client/archive/v${version}.tar.gz";
  #  sha256 = "14c0876mxz3xa2k4d665kf8j6k3hc6qybkj0gr4pr9c9gs70cgjh";
  #};

  buildInputs = lib.optionals stdenv.isDarwin [
    AVFoundation AudioToolbox ImageIO CoreMedia Foundation CoreGraphics MediaToolbox
    # Needed for OBJC_CLASS_$_NSData symbols.
    cf-private
  ];
  buildFlags = [ "-tags production" ];

  postInstall = lib.optionalString stdenv.hostPlatform.isLinux ''
    install -Dm644 \
      -t $out/lib/systemd/user \
      $NIX_BUILD_TOP/go/src/${goPackagePath}/packaging/linux/systemd/{kbfs,keybase,keybase-redirector,keybase.gui}.service
  '';

  meta = with lib; {
    homepage = https://www.keybase.io/;
    description = "The Keybase official command-line utility and service.";
    platforms = platforms.linux ++ platforms.darwin;
    maintainers = with maintainers; [ carlsverre np rvolosatovs ];
  };
}
