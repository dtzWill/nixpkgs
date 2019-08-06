{stdenv, fetchurl, libnl, pkgconfig}:

stdenv.mkDerivation rec {
  pname = "iw";
  version = "5.3";

  src = fetchurl {
    url = "https://www.kernel.org/pub/software/network/${pname}/${pname}-${version}.tar.xz";
    sha256 = "1m85ap8hwzfs7xf9r0v5d55ra4mhw45f6vclc7j6gsldpibyibq4";
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ libnl ];

  makeFlags = [ "PREFIX=${placeholder "out"}" ];

  meta = {
    description = "Tool to use nl80211";
    homepage = http://wireless.kernel.org/en/users/Documentation/iw;
    license = stdenv.lib.licenses.isc;
    maintainers = with stdenv.lib.maintainers; [viric];
    platforms = with stdenv.lib.platforms; linux;
  };
}
