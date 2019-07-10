{ stdenv, lib, fetchurl, zlib, openssl, ncurses, libidn, pcre, libssh, mysql, postgresql
, withGUI ? false, makeWrapper, pkgconfig, gtk2 }:

let
  makeDirs = output: subDir: pkgs: lib.concatStringsSep " " (map (path: lib.getOutput output path + "/" + subDir) pkgs);

in stdenv.mkDerivation rec {
  pname = "thc-hydra";
  version = "9.0";

  src = fetchurl {
    url = "https://github.com/vanhauser-thc/THC-Archive/raw/master/Tools/hydra-${version}.tar.gz";
    sha256 = "03ldivazd7h0b983b94v59v96smsb5ppzrqrzfkbm2hj7hjjwrsn";
  };

  preConfigure = ''
    substituteInPlace configure \
      --replace "\$LIBDIRS" "${makeDirs "lib" "lib" buildInputs}" \
      --replace "\$INCDIRS" "${makeDirs "dev" "include" buildInputs}" \
      --replace "/usr/include/math.h" "${lib.getDev stdenv.cc.libc}/include/math.h" \
      --replace "libcurses.so" "libncurses.so" \
      --replace "-lcurses" "-lncurses"
  '';

  nativeBuildInputs = lib.optionals withGUI [ pkgconfig makeWrapper ];
  buildInputs = [ zlib openssl ncurses libidn pcre libssh mysql.connector-c postgresql ]
                ++ lib.optional withGUI gtk2;

  postInstall = lib.optionalString withGUI ''
    wrapProgram $out/bin/xhydra \
      --add-flags --hydra-path --add-flags "$out/bin/hydra"
  '';

  meta = with stdenv.lib; {
    description = "A very fast network logon cracker which support many different services";
    license = licenses.agpl3;
    homepage = https://www.thc.org/thc-hydra/;
    maintainers = with maintainers; [offline];
    platforms = platforms.linux;
  };
}
