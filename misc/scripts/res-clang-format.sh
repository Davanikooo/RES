#! /usr/bin/env bash
## vim:set ts=4 sw=4 et:
set -e; set -o pipefail

# Copyright (C) Markus Franz Xaver Johannes Oberhumer
#
# "Gofmt's style is nobody's favourite, but gofmt is everybody's favourite." --Rob Pike
#
# NOTE: we are using clang-format-15.0.6 from resize-stubtools
# see https://github.com/resize/resize-stubtools/releases
#
# NOTE: we use .clang-format config from resize.git/.clang-format

if [[ ! -f $RESIZE_CLANG_FORMAT ]]; then
    RESIZE_CLANG_FORMAT="$HOME/local/bin/bin-resize/clang-format-15.0.6"
fi
if [[ ! -f $RESIZE_CLANG_FORMAT ]]; then
    RESIZE_CLANG_FORMAT="$HOME/.local/bin/bin-resize/clang-format-15.0.6"
fi
if [[ ! -f $RESIZE_CLANG_FORMAT ]]; then
    RESIZE_CLANG_FORMAT="$HOME/bin/bin-resize/clang-format-15.0.6"
fi
if [[ ! -f $RESIZE_CLANG_FORMAT ]]; then
    echo "ERROR: $0: cannot find clang-format-15.0.6"
    echo "ERROR: $0: please visit https://github.com/resize/resize-stubtools"
    exit 1
fi

# limit memory usage to 1 GiB (in case of clang-format problems with invalid files)
ulimit -v 1048576 || true

#echo "$RESIZE_CLANG_FORMAT"
exec "$RESIZE_CLANG_FORMAT" -style=file "$@"
exit 99
