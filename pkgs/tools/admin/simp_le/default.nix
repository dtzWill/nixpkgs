{ stdenv, python3Packages, bash }:

python3Packages.buildPythonApplication rec {
  pname = "simp_le-client";
  version = "0.17.0";

  src = python3Packages.fetchPypi {
    inherit pname version;
    sha256 = "0m1jynar4calaffp2zdxr5yy9vnhw2qf2hsfxwzfwf8fqb5h7bjb";
  };

  postPatch = ''
    # drop upper bound of idna requirement
    sed -ri "s/'(idna)<[^']+'/'\1'/" setup.py
    # allow acme 0.40 experimentally
    substituteInPlace setup.py --replace "'acme>=0.39,<0.40'" "'acme>=0.39,<0.41'"
    substituteInPlace simp_le.py \
      --replace "/bin/sh" "${bash}/bin/sh"
  '';

  checkPhase = ''
    $out/bin/simp_le --test
  '';

  propagatedBuildInputs = with python3Packages; [ acme setuptools_scm josepy idna ];

  meta = with stdenv.lib; {
    homepage = https://github.com/zenhack/simp_le;
    description = "Simple Let's Encrypt client";
    license = licenses.gpl3;
    maintainers = with maintainers; [ gebner makefu ];
    platforms = platforms.linux;
  };
}
