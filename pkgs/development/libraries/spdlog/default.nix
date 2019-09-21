{ stdenv, fetchFromGitHub, cmake }:

let
  generic = { version, sha256 }:
    stdenv.mkDerivation {
      name = "spdlog-${version}";
      inherit version;

      src = fetchFromGitHub {
        owner  = "gabime";
        repo   = "spdlog";
        rev    = "v${version}";
        inherit sha256;
      };

      nativeBuildInputs = [ cmake ];

      cmakeFlags = [ "-DSPDLOG_BUILD_EXAMPLES=OFF" "-DSPDLOG_BUILD_BENCH=OFF" ];

      outputs = [ "out" "doc" ];

      postInstall = ''
        mkdir -p $out/share/doc/spdlog
        cp -rv ../example $out/share/doc/spdlog
      '';

      meta = with stdenv.lib; {
        description    = "Very fast, header only, C++ logging library.";
        homepage       = https://github.com/gabime/spdlog;
        license        = licenses.mit;
        maintainers    = with maintainers; [ obadz ];
        platforms      = platforms.all;
      };
    };
in
{
  spdlog_1 = generic {
    version = "1.4.0";
    sha256 = "058r6z6nsvachx0rcq4zaa5rvqqk6gin8i7ifawb5sqgfj74q3rl";
  };

  spdlog_0 = generic {
    version = "0.17.0";
    sha256 = "112kfh4fbpm5cvrmgbgz4d8s802db91mhyjpg7cwhlywffnzkwr9";
  };
}
