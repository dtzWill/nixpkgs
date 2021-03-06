{ stdenv, fetchurl, fetchpatch, pkgconfig, autoreconfHook, doxygen }:

stdenv.mkDerivation rec {
  pname = "libqb";
  version = "1.0.5";

  src = fetchurl {
    url = "https://github.com/ClusterLabs/libqb/releases/download/v${version}/${pname}-${version}.tar.xz";
    sha256 = "0b5qh98y7a84297sq9ag4sr296dif4bpdza3gslisn9r5098cyr7";
  };

  nativeBuildInputs = [ autoreconfHook pkgconfig doxygen ];

  outputs = [ "out" "dev" "doc" "man" ];

  patches = [
    (fetchurl {
      url = "https://github.com/ClusterLabs/libqb/commit/6d62b64752c2a94acc3974be4b2528f4d05363cf.patch";
      sha256 = "178ygfq6v4qla1b39i5q44083d6jbiihcr6b29dir78kysv426bz";
    })
  ];

  # Purity fix
  preFixup = ''
    grep -q "$TMPDIR" "$out"/lib/libqb.la
    sed -i "s,\(inherited_linker_flags='\).*,\1'," "$out"/lib/libqb.la
  '';

  meta = with stdenv.lib; {
    homepage = https://github.com/clusterlabs/libqb;
    description = "A library providing high performance logging, tracing, ipc, and poll";
    license = licenses.lgpl21;
    platforms = platforms.unix;
  };
}
