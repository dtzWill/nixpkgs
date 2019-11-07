{ stdenv, fetchgit, fetchNodeModules, buildPythonPackage
, pgpy, flask, bleach, misaka, humanize, markdown, psycopg2, pygments, requests
, sqlalchemy, flask_login, beautifulsoup4, sqlalchemy-utils, celery, alembic
, importlib-metadata
, sassc, nodejs
, writeText }:

buildPythonPackage rec {
  pname = "srht";
  version = "0.54.4";

  src = fetchgit {
    url = "https://git.sr.ht/~sircmpwn/core.sr.ht";
    rev = version;
    sha256 = "0flxvn178hqd8ljz89ddis80zfnmzgimv4506w4dg2flbwzywy7z";
  };

  node_modules = fetchNodeModules {
    src = "${src}/srht";
    inherit nodejs;
    sha256 = "0axl50swhcw8llq8z2icwr4nkr5qsw2riih0a040f9wx4xiw4p6p";
  };

  patches = [
    ./disable-npm-install.patch
  ];

  nativeBuildInputs = [
    sassc
    nodejs
  ];

  propagatedBuildInputs = [
    pgpy
    flask
    bleach
    misaka
    humanize
    markdown
    psycopg2
    pygments
    requests
    sqlalchemy
    flask_login
    beautifulsoup4
    sqlalchemy-utils

    # Unofficial runtime dependencies?
    celery
    alembic
    importlib-metadata
  ];

  PKGVER = version;

  preBuild = ''
    cp -r ${node_modules} srht/node_modules
  '';

  # No actual? tests but seems like it needs this anyway
  preCheck = let
    config = writeText "config.ini" ''
      [webhooks]
      private-key=K6JupPpnr0HnBjelKTQUSm3Ro9SgzEA2T2Zv472OvzI=

      [meta.sr.ht]
      origin=http://meta.sr.ht.local
    '';
  in ''
    # Validation needs config option(s)
    # webhooks <- ( private-key )
    # meta.sr.ht <- ( origin )
    cp ${config} config.ini
  '';

  meta = with stdenv.lib; {
    homepage = https://git.sr.ht/~sircmpwn/srht;
    description = "Core modules for sr.ht";
    license = licenses.bsd3;
    maintainers = with maintainers; [ eadwu ];
  };
}
