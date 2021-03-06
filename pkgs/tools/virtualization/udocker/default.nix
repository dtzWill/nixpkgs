{ stdenv, fetchFromGitHub, proot, patchelf, fakechroot, runc, simplejson, pycurl, coreutils, nose, mock, buildPythonApplication }:

buildPythonApplication rec {

  version = "1.1.4";
  pname = "udocker";

  src = fetchFromGitHub rec {
    owner = "indigo-dc";
    repo = "udocker" ;
    rev = "v${version}";
    sha256 = "014p38vk2chs75hmsqpq3sas1mr3h05q3m4qdrg38a99sms0qf84";
  };

  buildInputs = [ proot patchelf fakechroot runc simplejson pycurl coreutils ];

  postPatch = ''
      substituteInPlace udocker.py --replace /usr/sbin:/sbin:/usr/bin:/bin $PATH
      substituteInPlace udocker.py --replace /bin/chmod ${coreutils}/bin/chmod
      substituteInPlace udocker.py --replace /bin/rm ${coreutils}/bin/rm
      substituteInPlace tests/unit_tests.py --replace /bin/rm ${coreutils}/bin/rm
      substituteInPlace udocker.py --replace "autoinstall = True" "autoinstall = False"
  '';

  checkInputs = [
    nose
    mock
  ];

  checkPhase = ''
    NOSE_EXCLUDE=test_03_create_repo,test_04_is_repo,test_02__get_group_from_host nosetests -v tests/unit_tests.py
  '';

  meta = with stdenv.lib; {
    description = "basic user tool to execute simple docker containers in user space without root privileges";
    homepage = https://indigo-dc.gitbooks.io/udocker;
    license = licenses.asl20;
    maintainers = [ maintainers.bzizou ];
    platforms = platforms.linux;
  };

}
