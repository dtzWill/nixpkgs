{ stdenv, python37Packages, fetchFromGitHub, fetchurl, dialog, autoPatchelfHook }:


python37Packages.buildPythonApplication rec {
  pname = "certbot";
  version = "1.1.0";

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = "v${version}";
    sha256 = "1k82gxg2qa40xnwx26xdznqvn4cffv59dk0d485xzbs5vc7a6wy5";
  };

  patches = [
    ./0001-Don-t-use-distutils.StrictVersion-that-cannot-handle.patch
  ];

  propagatedBuildInputs = with python37Packages; [
    ConfigArgParse
    acme
    configobj
    cryptography
    distro
    josepy
    parsedatetime
    psutil
    pyRFC3339
    pyopenssl
    pytz
    six
    zope_component
    zope_interface
  ];

  buildInputs = [ dialog ] ++ (with python37Packages; [ mock gnureadline ]);

  checkInputs = with python37Packages; [
    pytest_xdist
    pytest
    dateutil
  ];

  postPatch = ''
    cd certbot
    substituteInPlace certbot/_internal/notify.py --replace "/usr/sbin/sendmail" "/run/wrappers/bin/sendmail"
  '';

  postInstall = ''
    for i in $out/bin/*; do
      wrapProgram "$i" --prefix PYTHONPATH : "$PYTHONPATH" \
                       --prefix PATH : "${dialog}/bin:$PATH"
    done
  '';

  doCheck = true;

  meta = with stdenv.lib; {
    homepage = src.meta.homepage;
    description = "ACME client that can obtain certs and extensibly update server configurations";
    platforms = platforms.unix;
    maintainers = [ maintainers.domenkozar ];
    license = licenses.asl20;
  };
}
