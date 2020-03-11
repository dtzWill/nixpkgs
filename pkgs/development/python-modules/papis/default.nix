{ lib, buildPythonPackage, fetchFromGitHub, xdg_utils
, requests, filetype, pyparsing, configparser, arxiv2bib
, pyyaml, chardet, beautifulsoup4, colorama, bibtexparser
, pylibgen, click, python-slugify, habanero, isbnlib
, prompt_toolkit, pygments, stevedore, tqdm, lxml
, python-doi, isPy3k, pythonOlder
#, optional, dependencies
, whoosh, pytest
, stdenv
}:

buildPythonPackage rec {
  pname = "papis";
  version = "0.9";
  disabled = !isPy3k;

  # Missing tests on Pypi
  src = fetchFromGitHub {
    owner = "papis";
    repo = pname;
    rev = "v${version}";
    #rev = "1bbcfc001dd4449f9f99e89b4a63bd04f0373d4f";
    sha256 = "15i79q6nr7gcpcafdz5797axmp6r3081sys07k1k2vi5b2g3qc4k";
  };

  propagatedBuildInputs = [
    requests filetype pyparsing configparser arxiv2bib
    pyyaml chardet beautifulsoup4 colorama bibtexparser
    pylibgen click python-slugify habanero isbnlib
    prompt_toolkit pygments stevedore tqdm lxml python-doi
    # optional dependencies
    whoosh
  ];

  postPatch = ''
    substituteInPlace setup.py \
      --replace "lxml<=4.3.5" "lxml~=4.3" \
      --replace "python-slugify>=1.2.6,<4" "python-slugify"
  '';

  # pytest seems to hang with python3.8
  doCheck = !stdenv.isDarwin && pythonOlder "3.8";

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
        # expected failure: arxivid validation by querying sefver
        "test_validate_arxivid"
      ]}"
  '';

  #postInstall = ''
  #  install -D "scripts/shell_completion/click/papis.zsh" $out/share/zsh/site-functions/_papis
  #'';

  meta = {
    description = "Powerful command-line document and bibliography manager";
    homepage = https://papis.readthedocs.io/en/latest/;
    license = lib.licenses.gpl3;
    maintainers = with lib.maintainers; [ nico202 teto ];
  };
}
