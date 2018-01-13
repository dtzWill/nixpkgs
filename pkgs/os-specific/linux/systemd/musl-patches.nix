{ fetchFromGitHub, lib }:

let
  # 2018-01-13
  oe-core = fetchFromGitHub {
    owner = "openembedded";
    repo = "openembedded-core";
    rev = "5cf92ca436e1a1ba60fec8b30b6cb3cfd4842bc8";
    sha256 = "1f06y0l6jd3h74jcbqnmd06d09mmx686n9i2w0bjqn4xjmihs36w";
  };

  patchNames = [
    "0001-Define-_PATH_WTMPX-and-_PATH_UTMPX-if-not-defined.patch"
    "0001-Use-uintmax_t-for-handling-rlim_t.patch"
    "0001-add-fallback-parse_printf_format-implementation.patch"
    "0001-core-device.c-Change-the-default-device-timeout-to-2.patch"
    "0001-core-evaluate-presets-after-generators-have-run-6526.patch"
    "0001-main-skip-many-initialization-steps-when-running-in-.patch"
    "0002-src-basic-missing.h-check-for-missing-strndupa.patch"
    "0003-don-t-fail-if-GLOB_BRACE-and-GLOB_ALTDIRFUNC-is-not-.patch"
    "0004-Use-getenv-when-secure-versions-are-not-available.patch"
    "0004-src-basic-missing.h-check-for-missing-__compar_fn_t-.patch"
    "0005-binfmt-Don-t-install-dependency-links-at-install-tim.patch"
    "0006-Include-netinet-if_ether.h.patch"
    "0007-check-for-missing-canonicalize_file_name.patch"
    #"0007-use-lnr-wrapper-instead-of-looking-for-relative-opti.patch"
    "0008-Do-not-enable-nss-tests.patch"
    "0009-test-hexdecoct.c-Include-missing.h-form-strndupa.patch"
    "0010-implment-systemd-sysv-install-for-OE.patch"
    "0010-test-sizeof.c-Disable-tests-for-missing-typedefs-in-.patch"
    "0011-don-t-use-glibc-specific-qsort_r.patch"
    "0011-nss-mymachines-Build-conditionally-when-HAVE_MYHOSTN.patch"
    "0012-don-t-pass-AT_SYMLINK_NOFOLLOW-flag-to-faccessat.patch"
    "0012-rules-whitelist-hd-devices.patch"
    "0013-Make-root-s-home-directory-configurable.patch"
    "0013-comparison_fn_t-is-glibc-specific-use-raw-signature-.patch"
    "0014-Revert-rules-remove-firmware-loading-rules.patch"
    "0015-Revert-udev-remove-userspace-firmware-loading-suppor.patch"
    "0017-remove-duplicate-include-uchar.h.patch"
    "0018-check-for-uchar.h-in-configure.patch"
    "0019-socket-util-don-t-fail-if-libc-doesn-t-support-IDN.patch"
    "0020-rules-watch-metadata-changes-in-ide-devices.patch"
  ];
in lib.concatMapStrings (pname: ''
  patch -p1 -i ${oe-core}/meta/recipes-core/systemd/systemd/${pname}
'') patchNames
