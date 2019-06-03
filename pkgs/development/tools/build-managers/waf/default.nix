{ stdenv, fetchFromGitLab, fetchpatch, python, ensureNewerSourcesForZipFilesHook }:

stdenv.mkDerivation rec {
  name = "waf-${version}";
  version = "2.0.17";

  src = fetchFromGitLab {
    owner = "ita1024";
    repo = "waf";
    rev = name;
    sha256 = "16qpzzk32nz3rq160sgd8nq68r6b8dajb0fakhmiwjlj13p9f73y";
  };

  patches = [
    (fetchpatch {
      url = "https://gitlab.com/grahamc/waf/commit/fc1c98f1fb575fb26b867a61cbca79aa894db2ea.patch";
      sha256 = "0kzfrr6nh1ay8nyk0i69nhkkrq7hskn7yw1qyjxrda1y3wxj6jp8";
    })
  ];

  buildInputs = [ python ensureNewerSourcesForZipFilesHook ];

  configurePhase = ''
    python waf-light configure
  '';
  buildPhase = ''
    python waf-light build
  '';
  installPhase = ''
    install waf $out
  '';

  meta = with stdenv.lib; {
    description = "Meta build system";
    homepage    = https://waf.io;
    license     = licenses.bsd3;
    platforms   = platforms.all;
    maintainers = with maintainers; [ vrthra ];
  };
}
