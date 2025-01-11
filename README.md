# Atto-24
A small, pico-8 inspired fantasy console, with a burning desire to make you regret using it.

## Usage
For examples on the standard library, see `/test/`. But an example program is presented below. You are recommended to import the `stdlib`, to be able to use named functions for the syscalls.

Example:
```
#include <stdlib>;
#define helloString "Hello there, ";
#define NAME "John Doe";
sys mem.malloc 22,%B,%C;
sys str.join &helloString, &NAME, %B;
sys sys.printString %B;
sys mem.free %C;
exit;
```

This program demonstrates some of the capabilities of the compiler and interpreter, and serves as a basic hello world program. It should print `Hello there, John Doe`. Feel free to mess around with it to familiarize yourself with the syntax.

More docs can be found within the `/docs/` folder.

## Building

Atto-24 is written in D, and as such, if you don't have one, install a D compiler from [www.dlang.org](https://www.dlang.org/install). Then, if it's not bundled with your D compiler, install DUB, and run one of the install scripts, based on your platform.

