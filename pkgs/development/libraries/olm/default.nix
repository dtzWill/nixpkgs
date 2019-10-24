{ stdenv, fetchFromGitLab, cmake }:

stdenv.mkDerivation rec {
  pname = "olm";
  version = "3.1.4";

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
    rev = "6753595300767dd70150831dbbe6f92d64e75038"; # can't seem to specify the tag?
    sha256 = "06s7rw4a9vn35wzz7chxn54mp0sjgbpv2bzz9lq0g4hnzw33cjbi";
  };

  nativeBuildInputs = [ cmake ];

  doCheck = true;
}
