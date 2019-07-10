{ pkgs, nodejs, stdenv }:

let
  nodePackages = import ./composition-v12.nix {
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
  };
}
