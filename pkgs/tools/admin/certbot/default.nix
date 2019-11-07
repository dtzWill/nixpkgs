{ stdenv, python37Packages, fetchFromGitHub, fetchurl, dialog, autoPatchelfHook, nginx, pebble }:


python37Packages.buildPythonApplication rec {
  pname = "certbot";
  version = "0.40.1";

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = "v${version}";
    sha256 = "0kg0rr2iirmp5ggpidg7h6lmrcy9c4g7qwadzx3789csmw54yd66";
  };

  patches = [
    ./0001-pebble_artifacts-hardcode-pebble-location.patch
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
    substituteInPlace certbot/notify.py --replace "/usr/sbin/sendmail" "/run/wrappers/bin/sendmail"
    substituteInPlace certbot/util.py --replace "sw_vers" "/usr/bin/sw_vers"
    substituteInPlace certbot-ci/certbot_integration_tests/utils/pebble_artifacts.py --replace "@pebble@" "${pebble}/bin/pebble"
  '';

  postInstall = ''
    for i in $out/bin/*; do
      wrapProgram "$i" --prefix PYTHONPATH : "$PYTHONPATH" \
                       --prefix PATH : "${dialog}/bin:$PATH"
    done
  '';

  # tests currently time out, because they're trying to do network access
  # Upstream issue: https://github.com/certbot/certbot/issues/7450
  doCheck = false;

  checkPhase = ''
    PATH="$out/bin:${nginx}/bin:$PATH" pytest certbot-ci/certbot_integration_tests
  '';

  dontUseSetuptoolsCheck = true;

  meta = with stdenv.lib; {
    homepage = src.meta.homepage;
    description = "ACME client that can obtain certs and extensibly update server configurations";
    platforms = platforms.unix;
    maintainers = [ maintainers.domenkozar ];
    license = licenses.asl20;
  };
}
