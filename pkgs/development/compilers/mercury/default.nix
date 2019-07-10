{ stdenv, fetchurl, fetchFromGitHub, gcc, flex, bison, texinfo, makeWrapper ,
readline, jdk, erlang, autoconf, automake, libtool, pkgconfig }:


let
  mkMercury = stdenv.lib.makeOverridable mkMercury';
  mkMercury' = args @ { src, version, enableMinimal ? false, compilers ? [ gcc ], bootstrapMercury ? null, ... }:
    stdenv.mkDerivation (args // rec {
      name    = "mercury-${if enableMinimal then "minimal-" else ""}${version}";
      inherit src version;

      nativeBuildInputs = (args.nativeBuildInputs or []) ++ [
        flex bison texinfo makeWrapper
        bootstrapMercury 
      ];
      buildInputs = (args.buildInputs or [])
        ++ compilers ++ [ readline ];

      patchPhase = (args.patchPhase or "") + ''
        # Fix calls to programs in /bin
        for p in uname pwd ; do
          for f in $(egrep -lr /bin/$p *) ; do
            sed -i 's@/bin/'$p'@'$p'@g' $f ;
          done
        done
      '';

      preConfigure = (args.preConfigure or "") + ''
        mkdir -p $out/lib/mercury/cgi-bin
      '';

      configureFlags = (args.configureFlags or []) ++ [
        (
          if enableMinimal
          then "--enable-minimal-install"
          else "--enable-deep-profiler=${placeholder "out"}/lib/mercury/cgi-bin"
        )
      ];

      preBuild = (args.preBuild or "") + ''
        # Mercury buildsystem does not take -jN directly.
        makeFlags="PARALLEL=-j$NIX_BUILD_CORES" ;
      '';

      postInstall = (args.postInstall or "") + ''
        # Wrap with compilers for the different targets.
        for e in $(ls $out/bin) ; do
          wrapProgram $out/bin/$e \
            --prefix PATH ":" "${stdenv.lib.makeBinPath compilers}"
        done
      '';

      meta = {
        description = "A pure logic programming language";
        longDescription = ''
          Mercury is a logic/functional programming language which combines the
          clarity and expressiveness of declarative programming with advanced
          static analysis and error detection features.  Its highly optimized
          execution algorithm delivers efficiency far in excess of existing logic
          programming systems, and close to conventional programming systems.
          Mercury addresses the problems of large-scale program development,
          allowing modularity, separate compilation, and numerous optimization/time
          trade-offs.
        '';
        homepage    = "http://mercurylang.org";
        license     = stdenv.lib.licenses.gpl2;
        platforms = stdenv.lib.platforms.linux ++ stdenv.lib.platforms.darwin;
        maintainers = [ ];
      };
    });

in rec {
  mercury-14 = mkMercury rec {
    version = "14.01.1";
    src = fetchurl {
      url    = "https://dl.mercurylang.org/release/mercury-srcdist-${version}.tar.gz";
      sha256 = "12z8qi3da8q50mcsjsy5bnr4ia6ny5lkxvzy01a3c9blgbgcpxwq";
    };
  };
  mercury-14-bootstrap = mercury-14.override { enableMinimal = true; };
  mercury-14-full = mercury-14.override { compilers = [ gcc erlang jdk ]; };

  mercury-rotd = mkMercury rec {
    version = "rotd-2019-06-10";
    src = fetchFromGitHub {
      owner = "Mercury-Language";
      repo = "mercury-srcdist";
      rev = version;
      sha256 = "0fvkrmp2m8ac634pk14z3m2agrsxdav3z4vpwnn0dm2iw7n83v2d";
    };
    bootstrapMercury = mercury-rotd-bootstrap;
  };
  mercury-rotd-bootstrap = mercury-rotd.override {
    enableMinimal = true;
    bootstrapMercury = null;
  };
}
