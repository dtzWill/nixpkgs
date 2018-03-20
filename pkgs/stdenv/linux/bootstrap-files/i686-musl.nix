
{
  busybox = import <nix/fetchurl.nix> {
    url = https://wdtz.org/files/nr8xhx04mx7m2j8gnyif00vbk8jw3zh4-stdenv-bootstrap-tools-i686-unknown-linux-musl/on-server/busybox;
    sha256 = "1cnayg52s731acmy8phdpvfivjri5qgypsyp57hx97wrymijdzjp";
    executable = true;
  };
  bootstrapTools = import <nix/fetchurl.nix> {
    url = https://wdtz.org/files/nr8xhx04mx7m2j8gnyif00vbk8jw3zh4-stdenv-bootstrap-tools-i686-unknown-linux-musl/on-server/bootstrap-tools.tar.xz;
    sha256 = "00gwpw4b8vryrbmfmxr40mvcc3m2pk2wmycn86vi086pr9gcqx07";
  };
}
