{ stdenv, fetchurl, python3, which }:

stdenv.mkDerivation rec {
  pname = "fatrace";
  version = "0.14";

  src = fetchurl {
    url = "https://launchpad.net/${pname}/trunk/${version}/+download/${pname}-${version}.tar.xz";
    sha256 = "135vaxsv5phh03k32nzhapy4j8mrb4i9pl54w60yk60kh2d9jxnq";
  };

  buildInputs = [ python3 which ];

  postPatch = ''
    substituteInPlace power-usage-report \
      --replace "'which'" "'${which}/bin/which'"
  '';

  makeFlags = [ "PREFIX=${placeholder "out"}" ];

  meta = with stdenv.lib; {
    description = "Report system-wide file access events";
    homepage = https://launchpad.net/fatrace/;
    license = licenses.gpl3Plus;
    longDescription = ''
      fatrace reports file access events from all running processes.
      Its main purpose is to find processes which keep waking up the disk
      unnecessarily and thus prevent some power saving.
      Requires a Linux kernel with the FANOTIFY configuration option enabled.
      Enabling X86_MSR is also recommended for power-usage-report on x86.
    '';
    platforms = platforms.linux;
  };
}
