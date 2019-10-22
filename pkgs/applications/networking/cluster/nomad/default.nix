{ stdenv, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  pname = "nomad";
  version = "0.10.0";
  rev = "v${version}";

  goPackagePath = "github.com/hashicorp/nomad";
  subPackages = [ "." ];

  src = fetchFromGitHub {
    owner = "hashicorp";
    repo = "nomad";
    inherit rev;
    sha256 = "1hvnrbna4hsyp5byx5si2gn4h3m6shwmd8nk0vpbrs3ck3dl1p6l";
  };

  # We disable Nvidia GPU scheduling on Linux, as it doesn't work there:
  # Ref: https://github.com/hashicorp/nomad/issues/5535
  buildFlags = stdenv.lib.optionalString (stdenv.isLinux) "-tags nonvidia";

  meta = with stdenv.lib; {
    homepage = https://www.nomadproject.io/;
    description = "A Distributed, Highly Available, Datacenter-Aware Scheduler";
    platforms = platforms.unix;
    license = licenses.mpl20;
    maintainers = with maintainers; [ rushmorem pradeepchhetri ];
  };
}
