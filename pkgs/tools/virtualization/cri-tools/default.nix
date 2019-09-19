{ buildGoModule, fetchFromGitHub, lib }:

buildGoModule rec {
  pname = "cri-tools";
  version = "1.16.0";
  src = fetchFromGitHub {
    owner = "kubernetes-sigs";
    repo = pname;
    rev = "v${version}";
    sha256 = "0xb5pr762hi04cz0hq9w5xb31fbq2c6w0pp468pfkhwv3prq9gwy";
  };

  modSha256 = "0anzqgbqifd3mgnsn5agchifs1f9dafxjkdiifrfsf745g9wx29k";

  goPackagePath = "github.com/kubernetes-sigs/cri-tools";

  meta = with lib; {
    description = "CLI and validation tools for Kubelet Container Runtime Interface (CRI)";
    homepage = https://github.com/kubernetes-sigs/cri-tools;
    license = lib.licenses.asl20;
    maintainers = with maintainers; [ saschagrunert ];
  };
}
