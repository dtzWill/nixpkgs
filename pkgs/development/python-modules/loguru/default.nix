{ stdenv, buildPythonPackage, fetchPypi, isPy27, colorama, pytestCheckHook }:

buildPythonPackage rec {
  pname = "loguru";
  version = "0.3.1";
  
  disabled = isPy27;
  src = fetchPypi {
    inherit pname version;
    sha256 = "14pmxyx4kwyafdifqzal121mpdd89lxbjgn0zzi9z6fmzk6pr5h2";
  };

  checkInputs = [ pytestCheckHook colorama ];

  disabledTests = [ "test_time_rotation_reopening" "test_file_buffering" ]
    ++ stdenv.lib.optionals stdenv.isDarwin [ "test_rotation_and_retention" "test_rotation_and_retention_timed_file" "test_renaming" ];

  meta = with stdenv.lib; {
    homepage = https://github.com/Delgan/loguru;
    description = "Python logging made (stupidly) simple";
    license = licenses.mit;
    maintainers = with maintainers; [ jakewaksbaum ];
  };
}
