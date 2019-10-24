{ stdenv, fetchFromGitHub, meson, ninja, pkgconfig, gettext, libcsptr, dyncall, nanomsg, python3}:

stdenv.mkDerivation rec {
  pname = "boxfort";
  version = "unstable-2019-09-19";

  src = fetchFromGitHub {
    owner = "Snaipe";
    repo = pname;
    rev = "38fe63046fbabcae34ebc2ee9867d990ac28c4c5";
    sha256 = "03zy982d1frpk9fr4hbp1ql1ah06s0v6dy7a56d1zl3jjjljhrhn";
  };

  enableParallelBuilding = true;

  nativeBuildInputs = [ meson ninja pkgconfig gettext libcsptr dyncall nanomsg ];
  buildInputs = [ (python3.withPackages (ps: with ps; [ cram ])) ];

  postPatch = ''
    patchShebangs ci/isdir.py
  '';

  doCheck = true;

  # cmakeFlags = [ "-DBXF_TESTS=OFF" "-DBXF_SAMPLES=OFF" "-DBXF_FORK_RESILIENCE=OFF" ];
  # doCheck = false;

  meta = with stdenv.lib; {
    description = "Convenient & cross-platform sandboxing C library";
    homepage = "https://github.com/Snaipe/BoxFort";
    license = licenses.mit;
    maintainers = with maintainers; [ Yumasi ];
    platforms = platforms.unix;
  };
}
