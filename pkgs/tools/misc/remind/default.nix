{stdenv, fetchurl, tk, tcllib, makeWrapper
, tkremind ? true
} :

assert tkremind -> tk != null;
assert tkremind -> tcllib != null;
assert tkremind -> makeWrapper != null;

let
  inherit (stdenv.lib) optional optionalString;
  tclLibraries = stdenv.lib.optionals tkremind [ tcllib tk ];
  tclLibPaths = stdenv.lib.concatStringsSep " "
    (map (p: "${p}/lib/${p.libPrefix}") tclLibraries);
in stdenv.mkDerivation {
  pname = "remind";
  version = "3.3.0";
  src = fetchurl {
    url = https://dianne.skoll.ca/projects/remind/download/remind-03.03.00.tar.gz;
    sha256 = "06mnnf0wlvmi9vzildvz35cvjkxari5xb6n56shkp7753ac5p2cn";
  };

  nativeBuildInputs = optional tkremind makeWrapper;
  propagatedBuildInputs = tclLibraries;

  postPatch = optionalString tkremind ''
    substituteInPlace scripts/tkremind --replace "exec wish" "exec ${tk}/bin/wish"
  '';

  postInstall = optionalString tkremind ''
    wrapProgram $out/bin/tkremind --set TCLLIBPATH "${tclLibPaths}"
  '';

  meta = {
    homepage = https://dianne.skoll.ca/projects/remind/;
    description = "Sophisticated calendar and alarm program for the console";
    license = stdenv.lib.licenses.gpl2;
    maintainers = with stdenv.lib.maintainers; [raskin kovirobi];
    platforms = with stdenv.lib.platforms; linux;
  };
}
