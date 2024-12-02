# Vdiff
Visual  and  interactive  comparison  of  two  files  or directories. It is
written  as a console  application using ncurses  (it is a  Julia port of a
Ruby app "rdelta"). It can use the ncurses bindings in `TextUserInterfaces` 
or in `Ncurses`.

To start the application, you can either:

in the REPL

```
using Vdiff
vdiff("xxx","yyy")
```

where  "xxx" and "yyy" are two files or two directories to compare. In each
case  you get a window where help is available with "F1" of "h" or from the
menu.

Or from the command line, using the file `vdiff` that you have made executable
and whose contents are 
```
using Vdiff
Vdiff.main(ARGS...)
```
do then 
```
julia vdiff xxx yyy
```
The  program upon  first  use  makes a configuration file `~/.vdiff` whose
syntax  should be evident, which can be  updated by the options menu within
`Vdiff`.

[![Build Status](https://github.com/jmichel7/Vdiff.jl/actions/workflows/CI.yml/badge.svg?branch=main)](https://github.com/jmichel7/Vdiff.jl/actions/workflows/CI.yml?query=branch%3Amain)
