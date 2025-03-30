#!/bin/bash
#shellcheck source=/dev/null
dir=$(realpath "${0%/*}")
. "$dir/util.sh"
run_installer c "$@"
