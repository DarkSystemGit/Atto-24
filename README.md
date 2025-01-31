# Atto-24

A pico-8 inspired fantasy console, with a burning desire to make you regret using it.

## Usage

For examples on the standard library, see `/test/`. But an example program is presented below. You are recommended to import the `stdlib`, to be able to use named functions for the syscalls.

Example:

```
#include <stdlib>;
#define helloString "Hello there, ";
#define NAME "John Doe";
sys mem.malloc 22,%B,%C;
sys str.join &helloString, &NAME, %B;
sys io.printStr %B;
sys mem.free %C;
exit;
```

This program demonstrates some of the capabilities of the compiler and interpreter, and serves as a basic hello world program. It should print `Hello there, John Doe`. Feel free to mess around with it to familiarize yourself with the syntax.
For a full-on demo program, check out [Atto-Pong](https://www.github.com/darksystemgit/attopong). 
The docs can be found [here](/docs/index.md).

## Building

Atto-24 is written in D, and as such, if you don't have one, install `ldc` from [www.dlang.org](https://www.dlang.org/install). Then,run `scripts/install.sh`. `SDL2` is also a required dependency, install it from [libsdl.org](https://www.libsdl.org) or if on Linux, your package manager. On OSX, install directly from the SDL site, as for some reason the `brew` version isn't picked up. Windows isn't supported, but you can try to build it with WSL.

## Changelog

v1.0.0 - Initial release

v1.1.0 - Added interrupts, Multi-threading, and better docs. Simplified installation process.

