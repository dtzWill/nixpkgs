{ lib, buildPythonPackage, fetchFromGitHub, xdg_utils
, requests, filetype, pyparsing, configparser, arxiv2bib
, pyyaml, chardet, beautifulsoup4, colorama, bibtexparser
, pylibgen, click, python-slugify, habanero, isbnlib
, prompt_toolkit, pygments, stevedore, tqdm
#, optional, dependencies
, jinja2, whoosh, pytest
, stdenv
}:

buildPythonPackage rec {
  pname = "papis";
  version = "0.8.2";

  # Missing tests on Pypi
  src = fetchFromGitHub {
    owner = "papis";
    repo = pname;
    #rev = "v${version}";
    rev = "1bbcfc001dd4449f9f99e89b4a63bd04f0373d4f";
    sha256 = "05mqhdss6kbkw4kfgi6cg058v9xicnb0y0xnxjjgd0gmhk2z9bcl";
  };

  propagatedBuildInputs = [
    requests filetype pyparsing configparser arxiv2bib
    pyyaml chardet beautifulsoup4 colorama bibtexparser
    pylibgen click python-slugify habanero isbnlib
    prompt_toolkit pygments stevedore tqdm
    # optional dependencies
    jinja2 whoosh
  ];

  doCheck = !stdenv.isDarwin;

  checkInputs = ([
    pytest
  ]) ++ [
    xdg_utils
  ];

  # most of the downloader tests and 4 other tests require a network connection
  checkPhase = ''
    HOME=$(mktemp -d) pytest papis tests --ignore tests/downloaders \
      -k "not ${lib.concatStringsSep " and not " [
        "test_get_data"
        "test_doi_to_data"
        "test_general"
        "get_document_url"
        # dns resolution failures
        "test_downloader_getter"
        "test_validate_doi"
        # test_export_yaml and test_citations check for the exact output produced by pyyaml 3.x and
        # fail with 5.x
        "test_export_yaml"
        "test_citations"
      ]}"
  '';

  #postInstall = ''
  #  install -D "scripts/shell_completion/click/papis.zsh" $out/share/zsh/site-functions/_papis
  #'';

  meta = {
    description = "Powerful command-line document and bibliography manager";
    homepage = http://papis.readthedocs.io/en/latest/;
    license = lib.licenses.gpl3;
    maintainers = with lib.maintainers; [ nico202 teto ];
  };
}
