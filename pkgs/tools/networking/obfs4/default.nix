{ lib, fetchgit, buildGoModule }:

buildGoModule rec {
  pname = "obfs4";
  version = "0.0.11";

  src = fetchgit {
    url = meta.repositories.git;
    rev = "refs/tags/${pname}proxy-${version}";
    sha256 = "1y2kjwrk64l1h8b87m4iqsanib5rn68gzkdri1vd132qrlypycjn";
  };

  modSha256 = "0ajd007way1lwjsx712g1cijpzi3blvvqlycq1pmnab9m3d5snp2";

  meta = with lib; {
    description = "A pluggable transport proxy";
    homepage = https://www.torproject.org/projects/obfsproxy;
    repositories.git = https://git.torproject.org/pluggable-transports/obfs4.git;
    maintainers = with maintainers; [ phreedom thoughtpolice ];
  };
}
