# Atto-24 Docs

This file serves as the official reference for Atto development.

### Syntax

A guide to Atto's custom assembly language can be found in [syntax.md](syntax.md).

### Standard Library

The docs for the standard library are spread between 4 files:

[stdlib](stdlib.md) for most modules,

[io](io.md) for IO,

[thread](thread.md) for threading,

and [math](math.md) for mathematical operations.

You can also find info about interrupts in [interrupts](interrupts.md).
The header files for the standard library can be found in `/bin/include` directory of the install directory, which is typically `/etc/atto24`.
### Graphics

Documentation for Atto's graphics system can be found in [gfx.md](gfx.md). 

### Architecture
Atto-24 is based around single threads being the main unit of execution. Threads are created and managed by the main thread, thread 0.    
Each thread has a 96KB total working memory, and all threads share VRAM and the stack. VRAM is a 320 by 240 buffer of palette indices, which is swapped out to the screen by calling `gfx.render` . Palettes are lists of RGBA colors which can be set by the user.    
File operations work in the directory the program is run from, and may not leave that directory, effectively sandboxing the program to its \`cartridge\`.

### Examples
A pretty good example of a fully fleged game is Atto-Pong, which is a pong clone written for the Atto-24. It can be found [here](https://www.github.com/darksystemgit/attopong).