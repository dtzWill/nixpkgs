{ fetchFromGitHub, lib }:

let
  # 2018-03-06
  oe-core = fetchFromGitHub {
    owner = "openembedded";
    repo = "openembedded-core";
    rev = "086308aa2a5e332de6f00ed397c4a55d132f158f";
    sha256 = "0sx3hkw11afmhq6mg2fb69lgv6pha9fihna4a0cmg6yl0i11fijq";
  };

  patchNames = [
    #"0001-Hide-__start_BUS_ERROR_MAP-and-__stop_BUS_ERROR_MAP.patch"
    "0001-Use-getenv-when-secure-versions-are-not-available.patch"
    #"0002-binfmt-Don-t-install-dependency-links-at-install-tim.patch"
    #"0003-use-lnr-wrapper-instead-of-looking-for-relative-opti.patch"
    #"0004-implment-systemd-sysv-install-for-OE.patch"
    #"0005-rules-whitelist-hd-devices.patch"
    #"0006-Make-root-s-home-directory-configurable.patch"
    #"0007-Revert-rules-remove-firmware-loading-rules.patch"
    #"0008-Revert-udev-remove-userspace-firmware-loading-suppor.patch"
    "0009-remove-duplicate-include-uchar.h.patch"
    "0010-check-for-uchar.h-in-meson.build.patch"
    "0011-socket-util-don-t-fail-if-libc-doesn-t-support-IDN.patch"
    #"0012-rules-watch-metadata-changes-in-ide-devices.patch"
    "0013-add-fallback-parse_printf_format-implementation.patch"
    # https://gist.githubusercontent.com/dtzWill/0f85b1f506a5fa3346ca5bee58f7d389/raw/5c571e3ae1eeb1f9ded07fd400052551a43c0e9d/0001-src-basic-missing.h-check-for-missing-strndupa.patch
    #"0014-src-basic-missing.h-check-for-missing-strndupa.patch"
    #"0015-don-t-fail-if-GLOB_BRACE-and-GLOB_ALTDIRFUNC-is-not-.patch"
    "0016-src-basic-missing.h-check-for-missing-__compar_fn_t-.patch"
    "0017-Include-netinet-if_ether.h.patch"
    "0018-check-for-missing-canonicalize_file_name.patch"
    "0019-Do-not-enable-nss-tests-if-nss-systemd-is-not-enable.patch"
    "0020-test-hexdecoct.c-Include-missing.h-for-strndupa.patch"
    "0021-test-sizeof.c-Disable-tests-for-missing-typedefs-in-.patch"
    "0022-don-t-use-glibc-specific-qsort_r.patch"
    "0023-don-t-pass-AT_SYMLINK_NOFOLLOW-flag-to-faccessat.patch"
    "0024-comparison_fn_t-is-glibc-specific-use-raw-signature-.patch"
    "0025-Define-_PATH_WTMPX-and-_PATH_UTMPX-if-not-defined.patch"
    "0026-Use-uintmax_t-for-handling-rlim_t.patch"
    #"0027-remove-nobody-user-group-checking.patch"
    "0028-add-missing-FTW_-macros-for-musl.patch"
    "0029-nss-mymachines-Build-conditionally-when-ENABLE_MYHOS.patch"
    "0030-fix-missing-of-__register_atfork-for-non-glibc-build.patch"
    "0031-fix-missing-ULONG_LONG_MAX-definition-in-case-of-mus.patch"
  ];
in
  ''
  # strndupa
  patch -p1 -i ${builtins.fetchurl https://github.com/dtzWill/systemd/commit/0135a6a90c6606b1ec36f672aca959c5027a15c7.patch}
  # GLOB
  patch -p1 -i ${builtins.fetchurl https://github.com/dtzWill/systemd/commit/f0c8156d85bfe713106745bf40d3130de54aeb81.patch}
'' +
lib.concatMapStrings (pname: ''
  echo "Applying patch ${pname}..."
  echo patch -p1 -i ${oe-core}/meta/recipes-core/systemd/systemd/${pname}
  patch -p1 -i ${oe-core}/meta/recipes-core/systemd/systemd/${pname}
'') patchNames
