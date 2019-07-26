{ stdenv, fetchgit, asciidoc, docbook_xsl, libxslt }:

stdenv.mkDerivation rec {
  name    = "trace-cmd-${version}";
  version = "2.7";

  src = fetchgit {
    url    = "git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/trace-cmd.git";
    rev    = "refs/tags/trace-cmd-v${version}";
    sha256 = "13djbwfp52sg0kxg1n95x86dxcxiwhqlalrif06zg79jq4ry3rbx";
  };

  nativeBuildInputs = [ asciidoc libxslt ];

  dontConfigure = true;
  makeFlags = [
    "prefix=${placeholder "out"}"
    "MANPAGE_DOCBOOK_XSL=${docbook_xsl}/xml/xsl/docbook/manpages/docbook.xsl"
    "BASH_COMPLETE_DIR=${placeholder "out"}/etc/bash_completion.d"
  ];
  buildFlags = [ "all" "doc" ];
  installTargets = [ "install" "install_doc" ];

  meta = {
    description = "User-space tools for the Linux kernel ftrace subsystem";
    license     = stdenv.lib.licenses.gpl2;
    platforms   = stdenv.lib.platforms.linux;
    maintainers = [ stdenv.lib.maintainers.thoughtpolice ];
  };
}
