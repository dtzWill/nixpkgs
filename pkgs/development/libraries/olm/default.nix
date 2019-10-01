{ stdenv, fetchFromGitLab, cmake }:

stdenv.mkDerivation rec {
  pname = "olm";
  version = "3.1.3";

  meta = {
    description = "Implements double cryptographic ratchet and Megolm ratchet";
    license = stdenv.lib.licenses.asl20;
    homepage = https://matrix.org/git/olm/about;
    platforms = with stdenv.lib.platforms; darwin ++ linux;
  };

  src = fetchFromGitLab {
    domain = "gitlab.matrix.org";
    owner = "matrix-org";
    repo = "olm";
    rev = "ebd3ba6cc17862aefc9cb3299d60aeae953cc143"; # can't seem to specify the tag?
    sha256 = "19lpdhl6qvc8arahy4z0989q92paq68bd8a44x2ynwvppzhv37k2";
  };

  nativeBuildInputs = [ cmake ];

  doCheck = true;
}
