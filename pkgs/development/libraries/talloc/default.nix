{ stdenv, fetchurl, python, pkgconfig, which, readline, libxslt
, docbook_xsl, docbook_xml_dtd_42, fixDarwinDylibNames
, wafHook
}:

stdenv.mkDerivation rec {
  pname = "talloc";
  version = "2.2.0";

  src = fetchurl {
    url = "mirror://samba/${pname}/${pname}-${version}.tar.gz";
    sha256 = "1g1fqa37xkjp9lp6lrwxrbfgashcink769ll505zvcwnxx2nlvsw";
  };

  nativeBuildInputs = [ pkgconfig fixDarwinDylibNames which python wafHook
                        docbook_xsl docbook_xml_dtd_42 ];
  buildInputs = [ readline libxslt python ];

  wafPath = "buildtools/bin/waf";

  wafConfigureFlags = [
    #"--enable-talloc-compat1"
    "--bundled-libraries=NONE"
    "--builtin-libraries=replace"
  ];

  # this must not be exported before the ConfigurePhase otherwise waf whines
  preBuild = stdenv.lib.optionalString stdenv.hostPlatform.isMusl ''
    export NIX_CFLAGS_LINK="-no-pie -shared";
  '';

  postInstall = ''
    ${stdenv.cc.targetPrefix}ar q $out/lib/libtalloc.a bin/default/talloc_[0-9]*.o
  '';

  meta = with stdenv.lib; {
    description = "Hierarchical pool based memory allocator with destructors";
    homepage = https://tdb.samba.org/;
    license = licenses.gpl3;
    platforms = platforms.all;
  };
}
