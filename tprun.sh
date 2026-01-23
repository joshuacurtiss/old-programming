#!/bin/sh
#shellcheck source=util.sh
dir=$(realpath "${0%/*}")
. "$dir/util.sh"
check_dosbox

show_help() {
  echo "${bold}Compile and run a Pascal file with this script.$norm"
  echo
  echo "Example Usage: $bold$0 traction$norm"
  echo "Will run $ul$dir/pas/TRACTION.PAS$rmul."
  echo
  echo "DOS is case-insensitive. Will add $ul.pas$rmul to filename. Path is relative to:"
  echo "$ul$dir/pas$rmul"
  echo
  exit 1
}

target=$1
target_dir=$(dirname "$1")
target_file=$(basename -s .pas "$(echo "$target" | tr '[:upper:]' '[:lower:]')")
[ -z "$target" ] && show_help
target=$(echo "$target_dir/$target_file" | sed 's|/|\\|g')

dosbox-staging \
  --exit \
  -c "set PATH=%PATH%;C:\TP\BIN" \
  -c "del $target.exe" \
  -c "TPC.EXE -b $target.pas" \
  -c "$target.exe" \
  -c "pause" \
  "$dir/pas"
