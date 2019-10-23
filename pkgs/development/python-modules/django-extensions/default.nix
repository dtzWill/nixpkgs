{ lib, buildPythonPackage, fetchFromGitHub, pythonOlder
, six, typing
, django, shortuuid, python-dateutil, pytest
, pytest-django, pytestcov, mock, vobject
, werkzeug, glibcLocales
}:

buildPythonPackage rec {
  pname = "django-extensions";
  version = "2.2.3";

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = version;
    sha256 = "19bln9z25dmz1waqcxivlwg20dlm033c7f4z3h3mkhzkbk928y71";
  };

  postPatch = ''
    substituteInPlace setup.py --replace "'tox'," ""
  '';

  propagatedBuildInputs = [ six ] ++ lib.optional (pythonOlder "3.5") typing;

  checkInputs = [
    django shortuuid python-dateutil pytest
    pytest-django pytestcov mock vobject
    werkzeug glibcLocales
  ];

  LC_ALL = "en_US.UTF-8";

  meta = with lib; {
    description = "A collection of custom extensions for the Django Framework";
    homepage = https://github.com/django-extensions/django-extensions;
    license = licenses.mit;
  };
}
