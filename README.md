# Bash-Env

I use my computer for several different things and I work for several different
people and organisations. Across these roles I have access to different git repos,
different credentials and I need different tools.

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
app $PATH_TO_DIR_CONTAINING_GIT_REPOS
```

For example:
```
app "${HOME}/dev"
```
or:
```
app "${HOME}/work/folder_named_for_an_employer"
```
and then just `bashrc`

You can now use the name of your app to get to the git repos inside of the app
folder:

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
Scripts and other executables that I want in $PATH go here.

### completion.d
If I have made a completion script for a bin or a function, it goes here.

### lib
All of the BashEnv libs

### profile.d
Things go in here that I want to run with every terminal

### var
Everything ephemeral goes in here; don't store anything important here it's in
`.git_ignore`
