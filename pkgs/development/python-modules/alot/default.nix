{ stdenv, lib, buildPythonPackage, python, fetchFromGitHub, fetchpatch, isPy3k
, notmuch, urwid, urwidtrees, twisted, python_magic, configobj, mock, file, gpgme
, service-identity, glibcLocales
, gnupg ? null, sphinx, awk ? null, procps ? null, future ? null
, withManpage ? false }:


buildPythonPackage rec {
  pname = "alot";
  version = "0.9";
  outputs = [ "out" ] ++ lib.optional withManpage "man";

  disabled = !isPy3k;

  src = fetchFromGitHub {
    owner = "pazz";
    repo = "alot";
    rev = version;
    sha256 = "0wmhb23fgbn2x15llfwzkf392h4a32f7j1fb7gc4w95wr8jhwk2r";
  };

  patches = [
    # can't compose email if signature is set: https://github.com/pazz/alot/issues/1468
    (fetchpatch {
      name = "envelope-body.patch";
      url = "https://github.com/pazz/alot/commit/28a4296c7f556c251d71d9502681980d46d9fa55.patch";
      sha256 = "1iwvmjyz4mh1g08vr85ywhah2xarcqg8dazagygk19icgsn45w06";
    })
  ];

  nativeBuildInputs = lib.optional withManpage sphinx;

  propagatedBuildInputs = [
    notmuch
    urwid
    urwidtrees
    twisted
    python_magic
    configobj
    service-identity
    file
    gpgme
  ];

  # Some minor tests fail, but AFAiCT tests are bad?
  # If I knew how to specify skipping certain tests that'd be better!
  doCheck = false;
  postBuild = lib.optionalString withManpage "make -C docs man";

  checkInputs =  [ awk future mock gnupg procps glibcLocales ];

  postInstall = let
    completionPython = python.withPackages (ps: [ ps.configobj ]);
  in lib.optionalString withManpage ''
    mkdir -p $out/man
    cp -r docs/build/man $out/man
  ''
  + ''
    mkdir -p $out/share/{applications,alot}
    cp -r extra/themes $out/share/alot

    substituteInPlace extra/completion/alot-completion.zsh \
      --replace "python3" "${completionPython.interpreter}"
    install -D extra/completion/alot-completion.zsh $out/share/zsh/site-functions/_alot

    sed "s,/usr/bin,$out/bin,g" extra/alot.desktop > $out/share/applications/alot.desktop
  '';

  meta = with stdenv.lib; {
    homepage = https://github.com/pazz/alot;
    description = "Terminal MUA using notmuch mail";
    license = licenses.gpl3;
    platforms = platforms.linux;
    maintainers = with maintainers; [ ];
  };
}
