{ stdenv, fetchurl, autoreconfHook
, IOKit ? null , ApplicationServices ? null }:

let
  version = "7.1";

  # Use builtin drivedb.h for now, no database-update branch for this new release yet
  #dbrev = "5008";
  #drivedbBranch = "RELEASE_${builtins.replaceStrings ["."] ["_"] version}_DRIVEDB";
  #driverdb = fetchurl {
  #  url    = "https://sourceforge.net/p/smartmontools/code/${dbrev}/tree/branches/${drivedbBranch}/smartmontools/drivedb.h?format=raw";
  #  sha256 = "07x4haz65jyhj579h4z17v6jkw6bbyid34442gl4qddmgv2qzvwx";
  #  name   = "smartmontools-drivedb.h";
  #};

in stdenv.mkDerivation rec {
  pname = "smartmontools";
  inherit version;

  src = fetchurl {
    url = "mirror://sourceforge/smartmontools/${pname}-${version}.tar.gz";
    sha256 = "0imqb7ka4ia5573w8rnpck571pjjc9698pdjcapy9cfyk4n4swrz";
  };

  patches = [ ./smartmontools.patch ];
  # postPatch = "cp -v ${driverdb} drivedb.h";

  nativeBuildInputs = [ autoreconfHook ];
  buildInputs = [] ++ stdenv.lib.optionals stdenv.isDarwin [IOKit ApplicationServices];
  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    description = "Tools for monitoring the health of hard drives";
    homepage    = https://www.smartmontools.org/;
    license     = licenses.gpl2Plus;
    maintainers = with maintainers; [ peti ];
    platforms   = with platforms; linux ++ darwin;
  };
}
