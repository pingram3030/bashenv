# BashEnv

When working for multiple employers, or on different projects, it is handy to
separate out the location of git repositories used, in addition to making use
of different functions, aliases and variables.`

BashEnv is a system for helping to automate and standardise a bash environment.
It is designed to be modified and cloned on to multiple computers, but in a way
that enables localised customisations.

## Overview

Everything starts with `bashrc`. When sourced it creates several variables and
then it sources all shell files in `lib`, `profile.d` and `completion.d`. At
this point it expects to be located at `$HOME/.bash`, but that location can be
trivially modified.

## Usage

### Setup

`setup.sh` can be run from anywhere in the filesystem; JustWorks™. It:

1. Ensures that `$HOME/.bash` exists as a directory. If it doesn't exist it
    creates a symlink to the folder it resides in; no matter where this is.

1. Appends a line to `$HOME/.bashrc` to source `bashrc`. A handy `DEBUG` line is
    included, but commented out, to help when things go bang.

1. Checks for some basic packages and attempts installation. Currently it only
    cares about Fedora.

1. Installs some Ruby gems used for linting of `.rb` and `.md` files.

To use:

```
./setup.sh
```

### Admin

The `bashenv` function enables basic admin functionality for BashEnv. You can
tab complete its options for more info.

```
[user@host ~]$ bashenv -<tab><tab>
-h       --help   -r       --reset  -s       --setup  -t       --test
[user@host ~]$ bashenv --help
Usage: bashenv [-h|--help] [-r|--reset] [-s|--setup]
Perform basic functions for BashEnv. The default action, when run without
options, is to 'source ${ENV_BASHRC}' (/home/me/.bash/bashrc) and continue.

    -h, --help      show this help and exit
    -r, --reset     remove all var files and regenerate self
    -s, --setup     install self in to the shell of user: 'user'
    -t, --test      run bashate, rubocop and markdownlint
```

### Using

#### Environment

`environment` is a function that creates two functions. One that is directly
callable and use used to access contained git repos and the other is a
completion function to make use of the first function quicker and easier.

To make use of the auto-automatic completion functions and such, simply create
a shell file in `profile.d` with the contents of:

```
environment $PATH_TO_DIR_CONTAINING_GIT_REPOS
```

For example; I check out random git repos in to `~/dev`. `environment` will
create a function called 'dev' that can be used to access the repos it contains

```
[user@host ~]$ echo -e '#!/usr/bin/env bash\n\nenvironment ${HOME}/dev' > $ENV_ROOT/profile.d/dev.sh
```

The running of `bashenv` with no options makes the system reload itself:

```
[user@host ~]$ bashenv
BashEnv initialised
```

The `dev` function is now ready for use and it will tab complete all of the git
repos it finds.

```
[user@host ~]$ dev <tab><tab>
LineageOS               phoronix-test-suite     webdl
[user@host ~]$ dev phoronix-test-suite
* master
running 'git pull'
Already up-to-date.
[user@host phoronix-test-suite]$ pwd
/home/user/dev/phoronix-test-suite
```

## Structure

### bashrc

This is the magic sauce that makes everything work. It completely sets up
BashEnv and can be called at any time by executing `bashenv`.

### bin

Scripts and other executables that you want available in your $PATH go here.

### completion.d

If there is a completion script for a script or a function, it goes in here.

### lib

All of the BashEnv libs and anything that provides a function should go in
here. The `private` directory is excempt from version control and is chain
sourced.

### profile.d

ENV vars and other such things go in here. The `private` directory is excempt
from version control and is chain sourced.

### var

Everything ephemeral that is created by BashEnv goes in here. This directory
is git ignored, so don't use it for anything important.

