#!/bin/bash

export bold=
export rmul=
export ul=
export norm=
if command -v tput > /dev/null; then
  bold=$(tput bold)
  norm=$(tput sgr0)
  rmul=$(tput rmul)
  ul=$(tput smul)
fi

# Checks if dosbox-staging exists on the system, and offers to install it if not.
check_dosbox() {
  if ! command -v dosbox-staging > /dev/null; then
    if command -v brew > /dev/null; then
      echo 'You need to have dosbox-staging installed.'
      read -r -p "Do you want to install dosbox-staging using Homebrew? [Y/n] " yorn
      if [[ ${yorn:-Y} =~ [Yy] ]]; then
        brew install dosbox-staging
      else
        echo 'Okay, aborting.'
        exit 1
      fi
    else
      echo 'You must install dosbox-staging to use this script.'
      exit 1
    fi
  fi
}

# Checks that you passed args, and gives you instructions if you didn't.
check_installer_args() {
  if [ "$1" -eq 0 ]; then
    echo 'You must pass in the paths of the installer disk images. Something like this:'
    echo "$0 /path/to/installer/*.img"
    exit 1
  fi
}

# Installer for both TC and TP.
# First argument: Directory to mount ('c' or 'pas')
# Rest of arguments: Paths to installer disk images
run_installer() {
  check_dosbox
  e=$1
  shift
  check_installer_args $#
  args=(--exit)
  args+=(-c "mount C $dir/$e")
  args+=(-c "imgmount A -t floppy $*")
  args+=(-c "C:")
  args+=(-c "A:\INSTALL.EXE")
  dosbox-staging "${args[@]}"
}
