# Bash-Env

I use my computer for several different things and I work for several different
people and organisations. Across these roles I have access to different git repos,
different credentials and I need different tools.

## To Use
`setup.sh` can be run from anywhere in the filesystem; JustWorks™
```
./setup.sh
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
