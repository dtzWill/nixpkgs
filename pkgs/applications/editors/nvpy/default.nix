{ pkgs, fetchurl, python2Packages }:

let
  # TODO: python3!
  # Only python2 is supported currently, if py3 isn't officially supported
  # consider moving to this user's fork: https://github.com/cpbotha/nvpy/issues/153#issuecomment-431517564
  pythonPackages = python2Packages;
in pythonPackages.buildPythonApplication rec {
  version = "1.2.1";
  pname = "nvpy";

  src = fetchurl {
    url = "https://github.com/cpbotha/nvpy/archive/v${version}.tar.gz";
    sha256 = "1y5qkwfnp83b09sy1dn8qyqwcs1acbpq8jc0pzax5vy41459i0pq";
  };

  propagatedBuildInputs = with pythonPackages; [
    markdown
    tkinter
    docutils
    simplenote
  ];

  # No tests
  doCheck = false;

  postInstall = ''
    install -dm755 "$out/share/licenses/nvpy/"
    install -m644 LICENSE.txt "$out/share/licenses/nvpy/LICENSE"

    install -dm755 "$out/share/doc/nvpy/"
    install -m644 README.rst "$out/share/doc/nvpy/README"
  '';

  meta = with pkgs.lib; {
    description = "A simplenote-syncing note-taking tool inspired by Notational Velocity";
    homepage = https://github.com/cpbotha/nvpy;
    platforms = platforms.linux;
    license = licenses.bsd3;
  };
}
