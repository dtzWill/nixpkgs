# Use busybox for i686-linux since it works on x86_64-linux as well.
(import ./i686.nix) //

{
  bootstrapTools = import <nix/fetchurl.nix> {
    url = https://gravity.cs.illinois.edu/build/2177137/download/1/bootstrap-tools.tar.xz;
    sha256 = "eab723b47e516671c52fef9b11ac909d55a7745ed04dcc5ae294a1d974b144e0";
    # path: /nix/store/y4w65vk57lrf8z3li3dqzz6bsq6761lb-stdenv-bootstrap-tools/on-server/bootstrap-tools.tar.xz
  };
}
