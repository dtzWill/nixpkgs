{ stdenv, writeTextFile, llvm }:

with stdenv.lib;
let writeScriptBin' = name: text: writeTextFile {
  name = "${name}-${(builtins.parseDrvName llvm.name).version}";
  inherit text;
  executable = true;
  destination = "/bin/${name}";
}; in
writeScriptBin' "llvm-config" ''
  #!${stdenv.shell}

  while [[ $# -gt 0 ]]; do
    arg="$1"
    case $arg in
      --assertion-mode)
        echo "OFF"
        ;;
      --bindir)
        echo "${getBin llvm}/bin"
        ;;
      --libdir)
        echo "${getLib llvm}/lib"
        ;;
      --includedir)
        echo "${getDev llvm}/include"
        ;;
      --prefix)
        echo "${llvm.out}"
        ;;
      --src-root)
        echo "/build/llvm";
        ;;
      --obj-root)
        echo "/build/llvm/build";
        ;;
      --cmakedir)
        echo "${getDev llvm}/lib/cmake/llvm"
        ;;
      *)
        echo "Unhandled argument '$arg' passed to dummy llvm-config!"
        exit 1
    esac
    shift
  done
''
