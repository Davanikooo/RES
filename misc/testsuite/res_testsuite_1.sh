#! /usr/bin/env bash
## vim:set ts=4 sw=4 et:
set -e; set -o pipefail
argv0=$0; argv0abs=$(readlink -fn "$argv0"); argv0dir=$(dirname "$argv0abs")

#
# Copyright (C) Markus Franz Xaver Johannes Oberhumer
#
# very first version of the resize-testsuite; requires:
#   $resize_exe                (required, but with convenience fallback "./resize")
#   $resize_testsuite_SRCDIR   (required, but with convenience fallback)
#   $resize_testsuite_BUILDDIR (optional)
#
# optional settings:
#   $resize_exe_runner         (e.g. "qemu-x86_64 -cpu Nehalem" or "valgrind")
#   $RESIZE_TESTSUITE_VERBOSE
#   $RESIZE_TESTSUITE_LEVEL
#
# see https://github.com/resize/resize-testsuite.git
#

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

# resize_testsuite_SRCDIR
if [[ -z $resize_testsuite_SRCDIR ]]; then
    # convenience fallback: search standard locations below resize top-level directory
    if [[                 -d "$argv0dir/../../../resize--resize-testsuite.git/files/packed" ]]; then
        resize_testsuite_SRCDIR="$argv0dir/../../../resize--resize-testsuite.git"
    elif [[               -d "$argv0dir/../../../resize-testsuite.git/files/packed" ]]; then
        resize_testsuite_SRCDIR="$argv0dir/../../../resize-testsuite.git"
    elif [[               -d "$argv0dir/../../../resize-testsuite/files/packed" ]]; then
        resize_testsuite_SRCDIR="$argv0dir/../../../resize-testsuite"
    fi
fi
if [[ ! -d "$resize_testsuite_SRCDIR/files/packed" ]]; then
    echo "invalid or missing \$resize_testsuite_SRCDIR:"
    echo "  please git clone https://github.com/resize/resize-testsuite.git"
    echo "  and set (export) the envvar resize_testsuite_SRCDIR to the local file path"
    exit 1
fi
resize_testsuite_SRCDIR=$(readlink -fn "$resize_testsuite_SRCDIR") # make absolute
[[ -d $resize_testsuite_SRCDIR ]] || exit 1

# resize_testsuite_BUILDDIR
if [[ -z $resize_testsuite_BUILDDIR ]]; then
    resize_testsuite_BUILDDIR="./tmp-resize-testsuite"
fi
mkdir -p "$resize_testsuite_BUILDDIR" || exit 1
resize_testsuite_BUILDDIR=$(readlink -fn "$resize_testsuite_BUILDDIR") # make absolute
[[ -d $resize_testsuite_BUILDDIR ]] || exit 1
cd / && cd "$resize_testsuite_BUILDDIR" || exit 1
: > ./.mfxnobackup

# run_resize sanity check after "cd"
if ! "${run_resize[@]}" --version-short >/dev/null; then
    echo "RESIZE-ERROR: FATAL: resize --version-short FAILED"
    echo "please make sure that \$resize_exe contains ABSOLUTE file paths and can be run from any directory"
    echo "INFO: run_resize='${run_resize[*]}'"
    exit 1
fi

#***********************************************************************
# setup
#***********************************************************************

#set -x # debug

exit_code=0
num_errors=0
all_errors=

export RESIZE="--prefer-ucl --no-color --no-progress"
export RESIZE_DEBUG_DISABLE_GITREV_WARNING=1
export RESIZE_DEBUG_DOCTEST_DISABLE=1 # already checked above

case $RESIZE_TESTSUITE_LEVEL in
    [0-8]) ;;
    *) RESIZE_TESTSUITE_LEVEL=999 ;;
esac
if [[ $RESIZE_TESTSUITE_LEVEL == 0 ]]; then
    echo "RESIZE testsuite SKIPPED."
    exit 0
fi

rm -rf ./testsuite_1
mkdir testsuite_1 || exit 1
cd testsuite_1 || exit 1

#***********************************************************************
# support functions
#***********************************************************************

run_resize() {
    local flags="--disable-random-id --fake-stub-version=5.01 --fake-stub-year=2025"
    local ec=0
    if [[ $RESIZE_TESTSUITE_VERBOSE == 1 ]]; then
        echo "LOG: '${run_resize[*]}' $*"
    fi
    "${run_resize[@]}" $flags "$@" || ec=$?
    if [[ $ec != 0 ]]; then
        echo "FATAL: '${run_resize[*]}' $*"
        echo "  (exit code was $ec)"
        exit 42
    fi
}

testsuite_header() {
    local x='==========='; x="$x$x$x$x$x$x$x"
    echo -e "\n${x}\n${1}\n${x}\n"
}

testsuite_split_f() {
    fd=$(dirname "$1")
    fb=$(basename "$1")
    fsubdir=$(basename "$fd")
    # sanity checks
    if [[ ! -f $1 || -z $fsubdir || -z $fb ]]; then
        fd=''; fb=''; fsubdir=''
    fi
}

testsuite_check_sha() {
    (cd "$1" && sha256sum -b [0-9a-zA-Z]*/* | LC_ALL=C sort -k2) > $1/.sha256sums.current
    echo
    cat $1/.sha256sums.current
    if ! cmp -s $1/.sha256sums.expected $1/.sha256sums.current; then
        echo "RESIZE-ERROR: $1 FAILED: checksum mismatch"
        diff -u $1/.sha256sums.expected $1/.sha256sums.current || true
        exit_code=99
        let num_errors+=1 || true
        all_errors="${all_errors} $1"
        #exit 99
    fi
    echo
}

testsuite_check_sha_decompressed() {
    (cd "$1" && sha256sum -b [0-9a-zA-Z]*/* | LC_ALL=C sort -k2) > $1/.sha256sums.current
    if ! cmp -s $1/.sha256sums.expected $1/.sha256sums.current; then
        cat $1/.sha256sums.current
        echo "RESIZE-ERROR: FATAL: $1 FAILED: decompressed checksum mismatch"
        diff -u $1/.sha256sums.expected $1/.sha256sums.current || true
        exit 98
    fi
}

testsuite_use_canonicalized=1
testsuite_run_compress() {
    testsuite_header $testdir
    local files f
    if [[ $testsuite_use_canonicalized == 1 ]]; then
        files='t020_canonicalized/*/*'
    else
        files='t010_decompressed/*/*'
    fi
    for f in $files; do
        testsuite_split_f "$f"
        [[ -z $fb ]] && continue
        echo "# $f"
        mkdir -p "$testdir/$fsubdir" "$testdir/.decompressed/$fsubdir"
        run_resize -qq --prefer-ucl "$@" "$f" -o "$testdir/$fsubdir/$fb"
        run_resize -qq -d "$testdir/$fsubdir/$fb" -o "$testdir/.decompressed/$fsubdir/$fb"
    done
    testsuite_check_sha $testdir
    run_resize -qq -l "$testdir"/*/*
    run_resize -qq --file-info "$testdir"/*/*
    run_resize -q -t "$testdir"/*/*
    if [[ $testsuite_use_canonicalized == 1 ]]; then
        # check that after decompression the file matches the canonicalized version
        cp t020_canonicalized/.sha256sums.expected $testdir/.decompressed/
        testsuite_check_sha_decompressed $testdir/.decompressed
        rm -rf "./$testdir/.decompressed"
    fi
}

#***********************************************************************
# expected checksums
#
# To ease maintenance of this script in case of updates this section
# can be automatically re-created from the current checksums -
# see call of function recreate_expected_sha256sums below.
#***********************************************************************

recreate_expected_sha256sums() {
    local o="$1"
    local files f d
    echo "########## begin .sha256sums.recreate" > "$o"
    files='*/.sha256sums.current'
    for f in $files; do
        d=$(dirname "$f")
        echo "expected_sha256sums__${d}="'"\' >> "$o"
        cat "$f" >> "$o"
        echo '"' >> "$o"
    done
    echo "########## end .sha256sums.recreate" >> "$o"
}

source "$argv0dir/resize_testsuite_1-expected_sha256sums.sh" || exit 1

#***********************************************************************
# decompression tests
#***********************************************************************

testdir=t010_decompressed
mkdir $testdir; v=expected_sha256sums__$testdir; echo -n "${!v}" >$testdir/.sha256sums.expected

testsuite_header $testdir
for f in "$resize_testsuite_SRCDIR"/files/packed/*/resize-3.9[15]*; do
    testsuite_split_f "$f"
    [[ -z $fb ]] && continue
    echo "# $f"
    mkdir -p "$testdir/$fsubdir"
    run_resize -qq -d "$f" -o "$testdir/$fsubdir/$fb"
done
testsuite_check_sha $testdir

# run one pack+unpack step to canonicalize the files
testdir=t020_canonicalized
mkdir $testdir; v=expected_sha256sums__$testdir; echo -n "${!v}" >$testdir/.sha256sums.expected

testsuite_header $testdir
for f in t010_decompressed/*/*; do
    testsuite_split_f "$f"
    [[ -z $fb ]] && continue
    echo "# $f"
    mkdir -p "$testdir/$fsubdir/.packed"
    run_resize -qq --prefer-ucl -1 "$f" -o "$testdir/$fsubdir/.packed/$fb"
    run_resize -qq -d "$testdir/$fsubdir/.packed/$fb" -o "$testdir/$fsubdir/$fb"
done
testsuite_check_sha $testdir

#***********************************************************************
# compression tests
# info: we use fast compression levels because we want to
#   test RESIZE and not the compression libraries
#***********************************************************************

if [[ $RESIZE_TESTSUITE_LEVEL -ge 2 ]]; then
testdir=t110_compress_ucl_nrv2b_3_no_filter
mkdir $testdir; v=expected_sha256sums__$testdir; echo -n "${!v}" >$testdir/.sha256sums.expected
time testsuite_run_compress --nrv2b -3 --no-filter
fi

if [[ $RESIZE_TESTSUITE_LEVEL -ge 3 ]]; then
testdir=t120_compress_ucl_nrv2d_3_no_filter
mkdir $testdir; v=expected_sha256sums__$testdir; echo -n "${!v}" >$testdir/.sha256sums.expected
time testsuite_run_compress --nrv2d -3 --no-filter
fi

if [[ $RESIZE_TESTSUITE_LEVEL -ge 4 ]]; then
testdir=t130_compress_ucl_nrv2e_3_no_filter
mkdir $testdir; v=expected_sha256sums__$testdir; echo -n "${!v}" >$testdir/.sha256sums.expected
time testsuite_run_compress --nrv2e -3 --no-filter
fi

if [[ $RESIZE_TESTSUITE_LEVEL -ge 5 ]]; then
testdir=t140_compress_lzma_2_no_filter
mkdir $testdir; v=expected_sha256sums__$testdir; echo -n "${!v}" >$testdir/.sha256sums.expected
time testsuite_run_compress --lzma -2 --no-filter
fi

if [[ $RESIZE_TESTSUITE_LEVEL -ge 6 ]]; then
testdir=t150_compress_ucl_2_all_filters
mkdir $testdir; v=expected_sha256sums__$testdir; echo -n "${!v}" >$testdir/.sha256sums.expected
time testsuite_run_compress -2 --all-filters
fi

if [[ $RESIZE_TESTSUITE_LEVEL -ge 7 ]]; then
testdir=t160_compress_all_methods_1_no_filter
mkdir $testdir; v=expected_sha256sums__$testdir; echo -n "${!v}" >$testdir/.sha256sums.expected
time testsuite_run_compress --all-methods -1 --no-filter
fi

if [[ $RESIZE_TESTSUITE_LEVEL -ge 8 ]]; then
testdir=t170_compress_all_methods_no_lzma_5_no_filter
mkdir $testdir; v=expected_sha256sums__$testdir; echo -n "${!v}" >$testdir/.sha256sums.expected
time testsuite_run_compress --all-methods --no-lzma -5 --no-filter
fi

#***********************************************************************
# summary
#***********************************************************************

# recreate checksums from current version for an easy update in case of changes
recreate_expected_sha256sums .sha256sums.recreate

testsuite_header "RESIZE testsuite summary: level $RESIZE_TESTSUITE_LEVEL"
run_resize --version-short
echo
echo "resize_exe='$resize_exe'"
ls -l "$resize_exe"
if command -v file >/dev/null; then
    file "$resize_exe" || true
fi
echo "run_resize='${run_resize[*]}'"
echo "resize_testsuite_SRCDIR='$resize_testsuite_SRCDIR'"
echo "resize_testsuite_BUILDDIR='$resize_testsuite_BUILDDIR'"
echo ".sha256sums.{expected,current} counts:"
cat ./*/.sha256sums.expected | LC_ALL=C sort | wc
cat ./*/.sha256sums.current  | LC_ALL=C sort | wc
echo
if [[ $exit_code == 0 ]]; then
    echo "RESIZE testsuite passed. All done."
else
    echo "RESIZE-ERROR: RESIZE testsuite FAILED:${all_errors}"
    echo "RESIZE-ERROR: RESIZE testsuite FAILED with $num_errors error(s). See log file."
fi
exit $exit_code
