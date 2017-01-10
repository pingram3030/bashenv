# Bash-Env

Different computers are used for several different things such as working for
several different people and organisations. Across these roles and machines
there is a need to have access to different git repos, credentials and tools;
yet use the same aliases, functions and scripts.

## Usage

### Setup

`setup.sh` can be run from anywhere in the filesystem; JustWorks™

```
./setup.sh
```

### Using

To make use of the auto-automatic completion functions and such, simply create
a shell file in `profile.d` with the contents of:

```
environment $PATH_TO_DIR_CONTAINING_GIT_REPOS
```

For example:

```
[user@host ~]$ environment "${HOME}/dev"

```

And then just execute the `bashrc` function to reload the bashenv.

You can now use the name of your environment to get to its git repos.

For example:

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
BashEnv and can be called at any time by executing `bashrc`.

### bin

Scripts and other executables that are required to be in $PATH go here.

### completion.d

If there is a completion script for a bin or a function, it goes here.

### lib

All of the BashEnv libs and any private functions are needed go here.

### profile.d

Put ENV vars and other things in here; this is the best place to define an
'environment'.

### var

Everything ephemeral goes in here; don't store anything important here, it's in
`.gitignore`
