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
      # required by sharp
      # https://sharp.pixelplumbing.com/install
      vips

      nodePackages.node-pre-gyp
    ];
  };
}
