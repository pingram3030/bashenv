#!/usr/bin/env bash
#
# I keep all of my rando git checkouts in ~/dev
#
# This creates a bash function called "dev" which can be called to
# automatically `cd` to a git repo inside this dir and run `git pull`
#
# Usage: $ dev <tab><tab>
#

app "${HOME}/dev"
