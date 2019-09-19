{ stdenv
, fetch
, cmake
, zlib
, ncurses
, swig
, which
, libedit
, libxml2
, llvm
, clang-unwrapped
, python
, version
, darwin
# TODO: llvm-lit
}:

stdenv.mkDerivation rec {
  inherit version;
  pname = "lldb";

  src = fetch pname "1507dl0xw03nppxpz2xsq4s30jdbkplx4w14za54ngqm3xm2yk0y";

  patches = [ ./lldb-procfs.patch ];

  nativeBuildInputs = [ cmake python which swig ];
  buildInputs = [
    ncurses zlib libedit libxml2 llvm
  ]
  ++ stdenv.lib.optionals stdenv.isDarwin [
    darwin.libobjc darwin.apple_sdk.libs.xpc darwin.apple_sdk.frameworks.Foundation darwin.bootstrap_cmds darwin.apple_sdk.frameworks.Carbon darwin.apple_sdk.frameworks.Cocoa ];

  CXXFLAGS = "-fno-rtti";
  hardeningDisable = [ "format" ];

  cmakeFlags = [
    "-DLLDB_CODESIGN_IDENTITY=" # codesigning makes nondeterministic
    "-DClang_DIR=${clang-unwrapped}/lib/cmake"
  ];

  enableParallelBuilding = true;

  postInstall = ''
    # man page
    mkdir -p $out/share/man/man1
    install ../docs/lldb.1 -t $out/share/man/man1/

    # Editor support
    # vscode:
    install -D ../tools/lldb-vscode/package.json $out/share/vscode/extensions/llvm-org.lldb-vscode-0.1.0/package.json
    mkdir -p $out/share/vscode/extensions/llvm-org.lldb-vscode-0.1.0/bin
    ln -s $out/bin/lldb-vscode $out/share/vscode/extensions/llvm-org.lldb-vscode-0.1.0/bin
    # vim: (TODO: test, maybe help the plugin find lldb's python bits?)
    install -D ../utils/vim-lldb -t $out/share/vim-plugins
  '';

  meta = with stdenv.lib; {
    description = "A next-generation high-performance debugger";
    homepage    = http://llvm.org/;
    license     = licenses.ncsa;
    platforms   = platforms.all;
  };
}
