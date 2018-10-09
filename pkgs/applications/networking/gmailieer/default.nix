{ stdenv, fetchFromGitHub, fetchpatch, python3Packages }:

python3Packages.buildPythonApplication rec {
  name = "gmailieer-${version}";
  version = "0.9";

  src = fetchFromGitHub {
    owner = "gauteh";
    repo = "gmailieer";
    rev = "v${version}";
    sha256 = "1ixs5hip37hzcxwi2gsxp34r914f1wrl4r3swxqmzln3a15kngsk";
  };

  patches = [
    (fetchpatch {
      url = "https://github.com/gauteh/gmailieer/commit/544cade79ac6a9670a05dd84ca525926050656b9.patch";
      sha256 = "0c15bvi8lf451538cg5i8i54ipq0gifbjsy5k2zvmpywsvgh8jb7";
    })
  ];

  propagatedBuildInputs = with python3Packages; [
    notmuch
    oauth2client
    google_api_python_client
    tqdm
  ];

  meta = with stdenv.lib; {
    description      = "Fast email-fetching and two-way tag synchronization between notmuch and GMail";
    longDescription  = ''
      This program can pull email and labels (and changes to labels)
      from your GMail account and store them locally in a maildir with
      the labels synchronized with a notmuch database. The changes to
      tags in the notmuch database may be pushed back remotely to your
      GMail account.
    '';
    homepage         = https://github.com/gauteh/gmailieer;
    repositories.git = https://github.com/gauteh/gmailieer.git;
    license          = licenses.gpl3Plus;
    maintainers      = with maintainers; [ kaiha ];
  };
}
