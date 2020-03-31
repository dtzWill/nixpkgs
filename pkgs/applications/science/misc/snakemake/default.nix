{
  stdenv
, python
}:

python.buildPythonPackage rec {
  pname = "snakemake";
  version = "5.13.0";

  propagatedBuildInputs = with python; [
    appdirs
    ConfigArgParse
    datrie
    docutils
    GitPython
    jsonschema
    pyyaml
    ratelimiter
    requests
    wrapt
  ];

  src = python.fetchPypi {
    inherit pname version;
    sha256 = "11snr7sgv70d3y63s5svijfx8f4xpggh96g8chr6lccl4mi1s9x9";
  };

  doCheck = false; # Tests depend on Google Cloud credentials at ${HOME}/gcloud-service-key.json

  meta = with stdenv.lib; {
    homepage = "http://snakemake.bitbucket.io";
    license = licenses.mit;
    description = "Python-based execution environment for make-like workflows";
    longDescription = ''
      Snakemake is a workflow management system that aims to reduce the complexity of
      creating workflows by providing a fast and comfortable execution environment,
      together with a clean and readable specification language in Python style. Snakemake
      workflows are essentially Python scripts extended by declarative code to define
      rules. Rules describe how to create output files from input files.
    '';
    maintainers = with maintainers; [ helkafen renatoGarcia ];
  };
}
