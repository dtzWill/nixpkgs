{ stdenv, fetchgit, asciidoc, docbook_xsl, libxslt, audit }:

stdenv.mkDerivation rec {
  name    = "trace-cmd-${version}";
  version = "2.8.3";

  src = fetchgit {
    url    = "git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/trace-cmd.git";
    rev    = "refs/tags/trace-cmd-v${version}";
    sha256 = "1grpip7lywf98nsm7ql1d6bgc0ky0672savr8jz3a8hf9ny265nx";
  };

  nativeBuildInputs = [ asciidoc libxslt ];
  buildInputs =  [ audit ];

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
