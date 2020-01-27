# This is a copy of ninja's setup-hook.sh,
# modified to use samurai ("samu") instead.
#
# Variables keep the "ninja" prefix,
# unless they are specific to samurai
# (none of these have been added, yet).
# This makes it /possible/ for the same
# Nix expression to be used with samurai
# instead of ninja without any changes.
#

# Known differences/limitations:
# * check target auto-detection doesn't work
#   * (currently uses `query` tool
#      which samu doesn't support ye.)
# * parallel builds don't consider load average
#   (instead of "-j16 -l16", "-j16" is used)
#   * (samu doesn't support the '-l'  flag/feature)



samuBuildPhase() {
    runHook preBuild

    local buildCores=1

    # Parallel building is enabled by default.
    if [ "${enableParallelBuilding-1}" ]; then
        buildCores="$NIX_BUILD_CORES"
    fi

    local flagsArray=(
        -j$buildCores
        $ninjaFlags "${ninjaFlagsArray[@]}"
    )

    echoCmd 'build flags' "${flagsArray[@]}"
    samu "${flagsArray[@]}"

    runHook postBuild
}

if [ -z "${dontUseNinjaBuild-}" -a -z "${buildPhase-}" ]; then
    buildPhase=samuBuildPhase
fi

samuInstallPhase() {
    runHook preInstall

    # shellcheck disable=SC2086
    local flagsArray=(
        $ninjaFlags "${ninjaFlagsArray[@]}"
        ${installTargets:-install}
    )

    echoCmd 'install flags' "${flagsArray[@]}"
    samu "${flagsArray[@]}"

    runHook postInstall
}

if [ -z "${dontUseNinjaInstall-}" -a -z "${installPhase-}" ]; then
    installPhase=samuInstallPhase
fi

samuCheckPhase() {
    runHook preCheck

    if [ -z "${checkTarget:-}" ]; then
        echo "No checkTarget specified, samu doesn't support query tool yet, skipping..."
        # XXX: no 'query' tool
        #if samu -t query test >/dev/null 2>&1; then
        #    checkTarget=test
        #fi
    fi

    if [ -z "${checkTarget:-}" ]; then
        echo "no test target found in ninja, doing nothing"
    else
        local buildCores=1

        if [ "${enableParallelChecking-1}" ]; then
            buildCores="$NIX_BUILD_CORES"
        fi

        local flagsArray=(
            -j$buildCores
            $ninjaFlags "${ninjaFlagsArray[@]}"
            $checkTarget
        )

        echoCmd 'check flags' "${flagsArray[@]}"
        samu "${flagsArray[@]}"
    fi

    runHook postCheck
}

if [ -z "${dontUseNinjaCheck-}" -a -z "${checkPhase-}" ]; then
    checkPhase=samuCheckPhase
fi
