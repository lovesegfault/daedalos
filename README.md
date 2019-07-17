<img src=http://i.imgur.com/rX08oeR.jpg width=400 align=right>

# DaedalOS [![Build Status](https://travis-ci.org/lovesegfault/daedalos.svg?branch=master)](https://travis-ci.org/lovesegfault/daedalos)

DaedalOS is a simple, minimalistic OS written in Rust. The aim of this is to
create a small, self-written kernel that can run basic programs and, one day,
graphical applications. This project is for the x86_64 architecture.

## Current Status

The new build system is done, so now I'm back implementing the kernel. Working
on CPU exceptions currently

## Resources

This is a list of tutorials, articles, manuals and so on that are
references to the development of this project.

-   [Writing an OS in Rust][rust]
-   [Bare Bones Tutorial][barebones]
-   [Meaty Skeleton Tutorial][meaty]
-   [Kernel of Truth][kot]
-   [ToaruOS][toaruos]
-   [Intel x86 manual][intel]

## Building
First make sure you have QEMU available, then:

```shell
$ cargo install bootimage cargo-xbuild
$ cargo xbuild
```

## Testing
```shell
$ cargo xtest
```

## Running
```shell
$ cargo xrun
```

## TODO

-   Finish Meaty Skeleton

[rust]: os.phil-opp.com/

[barebones]: http://wiki.osdev.org/C%2B%2B_Bare_Bones

[meaty]: http://wiki.osdev.org/User:Sortie/Meaty_Skeleton

[kot]: https://github.com/iankronquist/kernel-of-truth

[toaruos]: https://github.com/klange/toaruos

[intel]: http://www.intel.com/content/www/us/en/processors/architectures-software-developer-manuals.html
