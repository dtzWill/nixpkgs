{ pkgs, nodejs, stdenv, fetchpatch }:

let
  nodePackages = import ./composition-v13.nix {
    inherit pkgs nodejs;
    inherit (stdenv.hostPlatform) system;
  };
in
nodePackages // {
  node2nix = nodePackages.node2nix.override {
    buildInputs = [ pkgs.makeWrapper ];
    postInstall = ''
      wrapProgram "$out/bin/node2nix" --prefix PATH : ${stdenv.lib.makeBinPath [ pkgs.nix ]}
    '';
  };

  joplin = nodePackages.joplin.override {
    nativeBuildInputs = [ pkgs.pkg-config ];
    buildInputs = with pkgs; [
      # sharp, dep list:
      # http://sharp.pixelplumbing.com/en/stable/install/
      cairo expat fontconfig freetype fribidi gettext giflib
      glib harfbuzz lcms libcroco libexif libffi libgsf
      libjpeg_turbo libpng librsvg libtiff vips
      libwebp libxml2 pango pixman zlib

      nodePackages.node-pre-gyp
    ];

    # Fix spewing debug info, remove on update
    preRebuild = ''
      patch -p2 -i ${fetchpatch {
        url = "https://github.com/laurent22/joplin/commit/7eabe74402e7a704505c11f3fc5b96a54e2ed4a6.patch";
        sha256 = "0lmy2v3lqalkj7zsyi5nzbx9sci2rpcpcv7vgni1kvx8aa02d7py";
      }}
    '';
  };
}
