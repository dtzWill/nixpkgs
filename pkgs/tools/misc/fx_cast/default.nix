{ stdenv, fetchurl, dpkg }:

stdenv.mkDerivation rec {
  pname = "fx_cast_bridge";
  version = "0.1.0";

  src = fetchurl {
     url = "https://github.com/hensm/fx_cast/releases/download/v${version}/${pname}-${version}-x64.deb";
     sha256 = "0hr7pf8vr154bjkzi4ys8zs8siipx4vb5r1n6cyjj2qili7l562n";
  };

  nativeBuildInputs = [ dpkg ];

  unpackPhase = ''
    runHook preUnpack
    dpkg-deb -xv $src ./
    runHook postUnpack
  '';

  dontBuild = true;
  dontPatchELF = true;

  installPhase = ''
    install -DT {opt/fx_cast,$out/bin}/${pname}
    install -DT {usr,$out}/lib/mozilla/native-messaging-hosts/${pname}.json

    substituteInPlace $out/lib/mozilla/native-messaging-hosts/${pname}.json \
      --replace {/opt/fx_cast,$out/bin}/${pname}
  '';

  # See now-cli/default.nix
  preFixup = let
    libPath = stdenv.lib.makeLibraryPath [stdenv.cc.cc stdenv.cc.libc];
    bin = "$out/bin/${pname}";
  in ''

    orig_size=$(stat --printf=%s ${bin})

    patchelf --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" ${bin}
    patchelf --set-rpath ${libPath} ${bin}
    chmod +x ${bin}

    new_size=$(stat --printf=%s ${bin})

    ###### zeit-pkg fixing starts here.
    # we're replacing plaintext js code that looks like
    # PAYLOAD_POSITION = '1234                  ' | 0
    # [...]
    # PRELUDE_POSITION = '1234                  ' | 0
    # ^-----20-chars-----^^------22-chars------^
    # ^-- grep points here
    #
    # var_* are as described above
    # shift_by seems to be safe so long as all patchelf adjustments occur
    # before any locations pointed to by hardcoded offsets

    var_skip=20
    var_select=22
    shift_by=$(expr $new_size - $orig_size)

    function fix_offset {
      # $1 = name of variable to adjust
      location=$(grep -obUam1 "$1" ${bin} | cut -d: -f1)
      location=$(expr $location + $var_skip)

      value=$(dd if=${bin} iflag=count_bytes,skip_bytes skip=$location \
                 bs=1 count=$var_select status=none)
      value=$(expr $shift_by + $value)

      echo -n $value | dd of=${bin} bs=1 seek=$location conv=notrunc
    }

    fix_offset PAYLOAD_POSITION
    fix_offset PRELUDE_POSITION

  '';
  dontStrip = true;

}
