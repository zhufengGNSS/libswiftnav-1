#!/bin/bash

# Copyright (C) 2018 Swift Navigation Inc.
# Contact: Swift Navigation <dev@swiftnav.com>

# Run Travis setup

set -ex
set -o errexit
set -o pipefail

#************************************************************************
# UTILITY FUNCTIONS
#************************************************************************
check_format_errors() {
  if [[ $(git --no-pager diff --name-only HEAD) ]]; then
    echo "######################################################"
    echo "####### clang-format warning found! Exiting... #######"
    echo "######################################################"
    echo ""
    echo "This should be formatted locally and pushed again..."
    git --no-pager diff
    travis_terminate 1
  fi
}

check_tidy_errors() {
  if [ -e ../fixes.yaml ]; then
    echo "####################################################"
    echo "####### clang-tidy warning found! Exiting... #######"
    echo "####################################################"
    echo ""
    echo " ^^ Please see and correct the clang-tidy warnings found above ^^"
    travis_terminate 1
  fi
}

function build() {
  # Create and enter build directory.
  mkdir -p build && cd build
  cmake ../
  make -j4 VERBOSE=1
  if [ "$TEST_SUITE" == "lint" ]; then
    make clang-format-all && check_format_errors
    ## keep clang-tidy disabled until the findings are addressed
    # make clang-tidy-all && check_tidy_errors
  fi
  cd ../
}

function git_update_submodules() {
  git submodule update --init --recursive
}

git_update_submodules
build
