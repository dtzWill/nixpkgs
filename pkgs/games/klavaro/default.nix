{ stdenv
, fetchurl
, makeWrapper
, curl
, file
, gtk3
, intltool
, pkgconfig
, espeak
}:

stdenv.mkDerivation rec {
  pname = "klavaro";
  version = "3.10";

  src = fetchurl {
    url = "mirror://sourceforge/klavaro/${pname}-${version}.tar.bz2";
    sha256 = "0jnzdrndiq6m0bwgid977z5ghp4q61clwdlzfpx4fd2ml5x3iq95";
  };

  nativeBuildInputs = [ intltool makeWrapper pkgconfig ];
  buildInputs = [ curl gtk3 ];

  patches = [ (builtins.toFile "format-string" ''
    Index: src/top10.c
    ===================================================================
    diff --git a/src/top10.c b/src/top10.c
    --- a/src/top10.c	(revision 105)
    +++ b/src/top10.c	(working copy)
    @@ -845,7 +845,7 @@
     		curl_easy_setopt (curl, CURLOPT_WRITEDATA, fh);
     		curl_easy_setopt (curl, CURLOPT_SSL_VERIFYPEER, 0L);
     		fail = curl_easy_perform (curl);
    -		if (fail) g_message (curl_easy_strerror (fail));
    +		if (fail) g_message ("error in download: %s", curl_easy_strerror (fail));
     		fclose (fh);
     	}
     	curl_easy_cleanup (curl);
  '') ];

  # Ensure dictation mode is available if desired.  As it's enabled by default
  # letting users desiring to opt-out use settings menu instead of build flag.
  # Happy to change if that's preferred :).
  postPatch = ''
    substituteInPlace src/tutor.c --replace '"espeak ' '"${espeak}/bin/espeak '
  '';

  postInstall = ''
    wrapProgram $out/bin/klavaro \
      --prefix LD_LIBRARY_PATH : $out/lib
  '';

  # Fixes /usr/bin/file: No such file or directory
  preConfigure = ''
    substituteInPlace configure \
      --replace "/usr/bin/file" "${file}/bin/file"
  '';

  # Hack to avoid TMPDIR in RPATHs.
  preFixup = ''rm -rf "$(pwd)" '';

  meta = with stdenv.lib; {
    description = "Free touch typing tutor program";
    homepage = "http://klavaro.sourceforge.net/";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [ mimame davidak ];
  };
}
