#!/bin/sh
#shellcheck source=/dev/null
dir=$(realpath "${0%/*}")
. "$dir/util.sh"
check_dosbox

dosbox-staging \
  --exit \
  -c "set PATH=%PATH%;C:\TC\BIN" \
  -c "TC.EXE $*" \
  "$dir/c"
