{ stdenv, fetchFromGitHub, keybase }:

keybase.overrideAttrs (o: let attrs = rec {
  pname = "keybase";
  version = "unstable-2020-01-27";
  name = "${pname}-${version}";

  src = fetchFromGitHub {
    owner = "keybase";
    repo = "client";
    rev = "v${version}";
    sha256 = "06rhnmk59was7dd5pd4czlrwqvmh02l9gka9561dkpl6w3j6814a";
  };

  pos = builtins.unsafeGetAttrPos "version" attrs;
}; in attrs)
