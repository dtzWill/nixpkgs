{ stdenv, fetchurl, dpkg }:

stdenv.mkDerivation rec {
  pname = "xidel";
  version = "0.9.8";

  ## Source archive lacks file (manageUtils.sh), using pre-built package for now.
  #src = fetchurl {
  #  url = "mirror://sourceforge/videlibri/Xidel/Xidel%20${version}/${pname}-${version}.src.tar.gz";
  #  sha256 = "177k59bg3smxpx8m2i5m6csqxhm6qrdw8s7264cad824zjib3dbj";
  #};

  src =
    if stdenv.hostPlatform.system == "x86_64-linux" then
      fetchurl {
        url = "mirror://sourceforge/videlibri/Xidel/Xidel%20${version}/xidel_${version}-1_amd64.deb";
        sha256 = "0sazjbva8m41qi6g3pkhnkpgksmkagb0ni43hgimlzalfydy59pn";
      }
    else if stdenv.hostPlatform.system == "i686-linux" then
      fetchurl {
        url = "mirror://sourceforge/videlibri/Xidel/Xidel%20${version}/xidel_${version}-1_i386.deb";
        sha256 = "0b3bw7sfhzby6dsi6867b2r4d89rcmky4xqgykqhwhys28jw0ac3";
      }
    else throw "xidel is not supported on ${stdenv.hostPlatform.system}";

  buildInputs = [ dpkg ];

  unpackPhase = ''
    dpkg-deb -x ${src} ./
  '';

  dontBuild = true;

  installPhase = ''
    mkdir -p "$out/bin"
    cp -a usr/* "$out/"
    patchelf --set-interpreter ${stdenv.cc.bintools.dynamicLinker} "$out/bin/xidel"
  '';

  meta = with stdenv.lib; {
    description = "Command line tool to download and extract data from html/xml pages";
    homepage = http://videlibri.sourceforge.net/xidel.html;
    # source contains no license info (AFAICS), but sourceforge says GPLv2
    license = licenses.gpl2;
    # more platforms will be supported when we switch to source build
    platforms = platforms.linux;
    maintainers = [ maintainers.bjornfor ];
  };
}
