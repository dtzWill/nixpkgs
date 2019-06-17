{ stdenv, lib, fetchFromGitHub, fetchpatch, cmake
, qtbase, qtquickcontrols, qtkeychain, qtmultimedia, qttools
, libqmatrixclient_0_5 }:

let
  generic = version: sha256: prefix: library: stdenv.mkDerivation rec {
    name = "quaternion-${version}";

    src = fetchFromGitHub {
      owner = "QMatrixClient";
      repo  = "Quaternion";
      rev   = "${prefix}${version}";
      inherit sha256;
    };

    patches = [
      # hyperlink users
      (fetchpatch {
        url = https://github.com/QMatrixClient/Quaternion/pull/580.patch;
        sha256 = "1r540f9naw3svyc1lgrd8bcvl9z3p652p2kahxr6v4j39mqb3k7c";
      })
    ];

    buildInputs = [ qtbase qtmultimedia qtquickcontrols qtkeychain qttools library ];

    nativeBuildInputs = [ cmake ];

    postInstall = if stdenv.isDarwin then ''
      mkdir -p $out/Applications
      mv $out/bin/quaternion.app $out/Applications
      rmdir $out/bin || :
    '' else ''
      substituteInPlace $out/share/applications/quaternion.desktop \
        --replace 'Exec=quaternion' "Exec=$out/bin/quaternion"
    '';

    meta = with lib; {
      description = "Cross-platform desktop IM client for the Matrix protocol";
      homepage    = https://matrix.org/docs/projects/client/quaternion.html;
      license     = licenses.gpl3;
      maintainers = with maintainers; [ peterhoeg ];
      inherit (qtbase.meta) platforms;
      inherit version;
    };
  };

  # This is the version from the submodule in latest quaternion
  qmtx_colors = libqmatrixclient_0_5.overrideAttrs(o: {
    src = fetchFromGitHub {
      owner = "QMatrixClient";
      repo = "libqmatrixclient";
      rev = "d6f39dcb0de69322479f287514a8c36afcb3fe7b";
      sha256 = "00n5qz8ahjvcwn3ssz7vdpglwx8gfmjp7yc72hpq5pcj9dh72xka";
    };
    #patches = (o.patches or []) ++ [
    #  (fetchpatch {
    #    url = https://github.com/QMatrixClient/libqmatrixclient/pull/298.patch;
    #    sha256 = "05h0wvx45rlqyzz1zfj24l7cwmxrxwkv5f88fzcvqbfq1hwm0542";
    #  })
    #];
  });

in rec {
  quaternion     = generic "0.0.9.4c"     "12mkwiqqbi4774kwl7gha72jyf0jf547acy6rw8ry249zl4lja54" "" libqmatrixclient_0_5;

  quaternion-git = quaternion;
  # quaternion-git = generic "4c999db5da4b56a2cac25fcb6a881abcfac673c2" "0ql883422ygm9i881clfn1p85br7lhzdalbz8di4zafhndwsdxr8" "" qmtx_colors;
}
