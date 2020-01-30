#!/bin/sh

# TODO: nix-shell

BASE="https://texlive.info/tlnet-archive"

# https://texlive.info/tlnet-archive/2019/12/06/tlnet/tlpkg/

VERSION="2019/12/06"

TLNET="$BASE/$VERSION/tlnet"
TLPDB="$TLNET/tlpkg/texlive.tlpdb.xz"

# pkgs
curl -L "$TLPDB" \
 | xzcat | uniq -u | sed -rn -f ./tl2nix.sed > ./pkgs.nix

# New prefix URL

ARCHIVE="$TLNET/archive"

echo "edit default.nix to use prefix url:"
echo "$ARCHIVE"

