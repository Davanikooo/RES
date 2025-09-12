#! /usr/bin/env bash
## vim:set ts=4 sw=4 et:
set -e; set -o pipefail
argv0=$0; argv0abs=$(readlink -fn "$argv0"); argv0dir=$(dirname "$argv0abs")

#
# Copyright (C) Markus Franz Xaver Johannes Oberhumer
#
# mimic running "ctest", i.e. the "test" section of CMakeLists.txt
#   - does not redirect stdout
#   - allows freely setting $resize_exe_runner, while CMake is restricted to configure-time settings
#
# requires:
#   $resize_exe                (required, but with convenience fallback "./resize")
# optional settings:
#   $resize_exe_runner         (e.g. "qemu-x86_64 -cpu Nehalem" or "valgrind")
#

# Debugging aid for locating failing commands.  Depends on 'bash' shell.
# (BASH_LINENO is relative to current FUNCTION only; non-function ==> 0)
# Notice single-quoting of entire first argument.
trap 'echo ERROR: pwd=\"$PWD\"  file=\"$BASH_SOURCE\"  line=${BASH_LINENO[0]}  cmd=\"$BASH_COMMAND\"' ERR
# Example: "false a b c" ==> ERROR: pwd="path/misc/testsuite" file="./mimic_ctest.sh" line=0 cmd="false a b c"

#***********************************************************************
# init & checks
#***********************************************************************

# resize_exe
[[ -z $resize_exe && -f ./resize && -x ./resize ]] && resize_exe=./resize # convenience fallback
if [[ -z $resize_exe ]]; then echo "RESIZE-ERROR: please set \$resize_exe"; exit 1; fi
if [[ ! -f $resize_exe ]]; then echo "RESIZE-ERROR: file '$resize_exe' does not exist"; exit 1; fi
resize_exe=$(readlink -fn "$resize_exe") # make absolute
[[ -f $resize_exe ]] || exit 1

# set emu and run_resize
emu=()
if [[ -n $resize_exe_runner ]]; then
    # usage examples:
    #   export resize_exe_runner="qemu-x86_64 -cpu Nehalem"
    #   export resize_exe_runner="valgrind --leak-check=no --error-exitcode=1 --quiet"
    #   export resize_exe_runner="wine"
    IFS=' ' read -r -a emu <<< "$resize_exe_runner" # split at spaces into array
elif [[ -n $CMAKE_CROSSCOMPILING_EMULATOR ]]; then
    IFS=';' read -r -a emu <<< "$CMAKE_CROSSCOMPILING_EMULATOR" # split at semicolons into array
fi
run_resize=( "${emu[@]}" "$resize_exe" )
echo "run_resize='${run_resize[*]}'"

# run_resize sanity check
if ! "${run_resize[@]}" --version-short >/dev/null; then echo "RESIZE-ERROR: FATAL: resize --version-short FAILED"; exit 1; fi
if ! "${run_resize[@]}" -L >/dev/null 2>&1; then echo "RESIZE-ERROR: FATAL: resize -L FAILED"; exit 1; fi
if ! "${run_resize[@]}" --help >/dev/null;  then echo "RESIZE-ERROR: FATAL: resize --help FAILED"; exit 1; fi

#***********************************************************************
# see CMakeLists.txt
#
# IDEA: create a Makefile and use "make -j8" so that these tests can
#   run in parallel much like "ctest --parallel 8"
#***********************************************************************

# similar to cmake function resize_cache_bool_vars()
set_cmake_bool_vars() {
    local default_value="$1"; shift
    local var_name
    for var_name do
        case "${!var_name}" in
            0 | FALSE | OFF | false | off) eval "export $var_name=OFF" ;;
            1 | TRUE | ON | true | on) eval "export $var_name=ON" ;;
            *) eval "export $var_name=$default_value" ;;
        esac
    done
}

set -x
set_cmake_bool_vars OFF RESIZE_CONFIG_DISABLE_SELF_PACK_TEST
set_cmake_bool_vars OFF RESIZE_CONFIG_DISABLE_RUN_UNPACKED_TEST
set_cmake_bool_vars OFF RESIZE_CONFIG_DISABLE_RUN_PACKED_TEST
if [[ "${emu[0]}" == *valgrind* ]]; then # valgrind is SLOW
    set_cmake_bool_vars ON  RESIZE_CONFIG_DISABLE_EXHAUSTIVE_TESTS
else
    set_cmake_bool_vars OFF RESIZE_CONFIG_DISABLE_EXHAUSTIVE_TESTS
fi

export RESIZE="--prefer-ucl --no-color --no-progress"
export RESIZE_DEBUG_DISABLE_GITREV_WARNING=1
export RESIZE_DEBUG_DOCTEST_DISABLE=1 # already checked above

"${run_resize[@]}" --version
"${run_resize[@]}" --version-short
"${run_resize[@]}" --license
"${run_resize[@]}" --help
"${run_resize[@]}" --help-short
"${run_resize[@]}" --help-verbose
"${run_resize[@]}" --sysinfo
"${run_resize[@]}" --sysinfo -v
"${run_resize[@]}" --sysinfo -vv

if [[ $RESIZE_CONFIG_DISABLE_SELF_PACK_TEST == ON ]]; then
    echo "Self-pack test disabled. All done."; exit 0
fi

exe=".out"
resize_self_exe=$resize_exe
fo="--force-overwrite"

"${run_resize[@]}" -3               "${resize_self_exe}" ${fo} -o resize-packed${exe}
"${run_resize[@]}" -3 --all-filters "${resize_self_exe}" ${fo} -o resize-packed-fa${exe}
"${run_resize[@]}" -3 --no-filter   "${resize_self_exe}" ${fo} -o resize-packed-fn${exe}
"${run_resize[@]}" -3 --all-filters --debug-use-random-filter "${resize_self_exe}" ${fo} -o resize-packed-fr${exe}
"${run_resize[@]}" -3 --nrv2b       "${resize_self_exe}" ${fo} -o resize-packed-nrv2b${exe}
"${run_resize[@]}" -3 --nrv2d       "${resize_self_exe}" ${fo} -o resize-packed-nrv2d${exe}
"${run_resize[@]}" -3 --nrv2e       "${resize_self_exe}" ${fo} -o resize-packed-nrv2e${exe}
"${run_resize[@]}" -1 --lzma        "${resize_self_exe}" ${fo} -o resize-packed-lzma${exe}

"${run_resize[@]}" -l         resize-packed${exe} resize-packed-fa${exe} resize-packed-fn${exe} resize-packed-fr${exe} resize-packed-nrv2b${exe} resize-packed-nrv2d${exe} resize-packed-nrv2e${exe} resize-packed-lzma${exe}
"${run_resize[@]}" --fileinfo resize-packed${exe} resize-packed-fa${exe} resize-packed-fn${exe} resize-packed-fr${exe} resize-packed-nrv2b${exe} resize-packed-nrv2d${exe} resize-packed-nrv2e${exe} resize-packed-lzma${exe}
"${run_resize[@]}" -t         resize-packed${exe} resize-packed-fa${exe} resize-packed-fn${exe} resize-packed-fr${exe} resize-packed-nrv2b${exe} resize-packed-nrv2d${exe} resize-packed-nrv2e${exe} resize-packed-lzma${exe}

"${run_resize[@]}" -d resize-packed${exe}       ${fo} -o resize-unpacked${exe}
"${run_resize[@]}" -d resize-packed-fa${exe}    ${fo} -o resize-unpacked-fa${exe}
"${run_resize[@]}" -d resize-packed-fn${exe}    ${fo} -o resize-unpacked-fn${exe}
"${run_resize[@]}" -d resize-packed-fr${exe}    ${fo} -o resize-unpacked-fr${exe}
"${run_resize[@]}" -d resize-packed-nrv2b${exe} ${fo} -o resize-unpacked-nrv2b${exe}
"${run_resize[@]}" -d resize-packed-nrv2d${exe} ${fo} -o resize-unpacked-nrv2d${exe}
"${run_resize[@]}" -d resize-packed-nrv2e${exe} ${fo} -o resize-unpacked-nrv2e${exe}
"${run_resize[@]}" -d resize-packed-lzma${exe}  ${fo} -o resize-unpacked-lzma${exe}

# all unpacked files must be identical
cmp -s resize-unpacked${exe} resize-unpacked-fa${exe}
cmp -s resize-unpacked${exe} resize-unpacked-fn${exe}
cmp -s resize-unpacked${exe} resize-unpacked-fr${exe}
cmp -s resize-unpacked${exe} resize-unpacked-nrv2b${exe}
cmp -s resize-unpacked${exe} resize-unpacked-nrv2d${exe}
cmp -s resize-unpacked${exe} resize-unpacked-nrv2e${exe}
cmp -s resize-unpacked${exe} resize-unpacked-lzma${exe}

if [[ $RESIZE_CONFIG_DISABLE_RUN_UNPACKED_TEST != ON ]]; then
    "${emu[@]}" ./resize-unpacked${exe} --version-short
fi

if [[ $RESIZE_CONFIG_DISABLE_RUN_PACKED_TEST != ON ]]; then
    "${emu[@]}" ./resize-packed${exe}       --version-short
    "${emu[@]}" ./resize-packed-fa${exe}    --version-short
    "${emu[@]}" ./resize-packed-fn${exe}    --version-short
    "${emu[@]}" ./resize-packed-fr${exe}    --version-short
    "${emu[@]}" ./resize-packed-nrv2b${exe} --version-short
    "${emu[@]}" ./resize-packed-nrv2d${exe} --version-short
    "${emu[@]}" ./resize-packed-nrv2e${exe} --version-short
    "${emu[@]}" ./resize-packed-lzma${exe}  --version-short
fi

if [[ $RESIZE_CONFIG_DISABLE_EXHAUSTIVE_TESTS != ON ]]; then
    set +x
    for method in nrv2b nrv2d nrv2e lzma; do
        for level in 1 2 3 4 5 6 7; do
            for small in normal small; do
                s="${method}-${level}"
                ss=
                if [[ $small == "small" ]]; then
                    s="${method}-${level}-${small}"
                    ss="--small"
                fi
                echo "========== $s =========="
                "${run_resize[@]}" -qq --${method} -${level} ${ss} --all-filters --debug-use-random-filter "${resize_self_exe}" ${fo} -o resize-packed-${s}${exe}
                "${run_resize[@]}" -qq -l resize-packed-${s}${exe}
                "${run_resize[@]}" -qq --fileinfo resize-packed-${s}${exe}
                "${run_resize[@]}" -qq -t resize-packed-${s}${exe}
                "${run_resize[@]}" -qq -d resize-packed-${s}${exe} ${fo} -o resize-unpacked-${s}${exe}
                cmp -s resize-unpacked${exe} resize-unpacked-${s}${exe}
                if [[ $RESIZE_CONFIG_DISABLE_RUN_PACKED_TEST != ON ]]; then
                    : ${resize_run_packed_test_count:=20}
                    for ((i = 0; i < $resize_run_packed_test_count; i++)); do
                        "${emu[@]}" ./resize-packed-${s}${exe} --version-short
                    done
                fi
            done
        done
    done
fi

echo "run_resize='${run_resize[*]}'"
echo "All done."
