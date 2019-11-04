{ stdenv, fetchurl, python3, which }:

stdenv.mkDerivation rec {
  pname = "fatrace";
  version = "0.15";

  src = fetchurl {
    url = "https://launchpad.net/${pname}/trunk/${version}/+download/${pname}-${version}.tar.xz";
    sha256 = "1b8rni4m4acw8vf0kz39dpn3l6jb3jf5af2ly2mqh2wc88ap2i7r";
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
