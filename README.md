# Atto-24
A small, pico-8 inspired fantasy console, with a burning desire to make you regret using it.

## Syntax
Atto-24 lets users program in a minimal RISC assembly language, enticing nostalgia for assembly. But we here at Atto Labs aren't evil, so we added a little sugar, to distract you from the pain.

The syntax is as following:


|    Type                |      Usage              |   Description                 |
|--------------------|--------------------|--------------------|
|        Defines            |       `#define` `name ` `value`             | Defines a constant value, which can be any type (String, Number, and Bools). Multi-byte values like strings should be refereed to by the address of operator, as such `&name`. This will add the value to the programs data section and replace `&name` with the address in the data section. Simply referring to a value by name substitutes it in place.                    |
|          Labels          |    `Name:`                |           Labels can be used to begin blocks of code, and when the name of a label is used in code, it will replace the name with the address  of the block.         |
| Commands | `command` `operand, operand` | Commands provide instructions for the CPU to execute, they are simply the name of the command, followed by a comma separated list of operands. Different commands may take different amounts of operands, and different amounts of time to execute.  |
| Registers | `%Register` | A register is a small area of memory used to hold numbers and single byte values for access. There are 10 different registers, from A-J. Different registers may have different types, with A-E being ints, F and G being floats, and H, I, and J being doubles. |
## Commands
A listing of available commands are below.

|       Name             |        Operands            |          Description          |
|--------------------|--------------------|--------------------|
|      NOP              |                    |   Does nothing                 |
|     ADD              |     int a, int b               |     Adds a and b and puts the sum in %A.               |
|   ADDF                 |    float a, float b              |         Adds a and b and puts the sum in %F.           |
|          SUB          |   int a, int b                 |            Subtracts b from a and puts the result in %A.       ||          SUBF          |   float a, float b                 |            Subtracts b from a and puts the result in %F.       |
|          MUL          |   int a, int b                 |            Multiplies a and b and puts the result in %A.       |
|         MULF          |   float a, float b                 |    Multiplies a and b and puts the result in %F. |
| DIV | float a, float b | Divides a and b and puts the result in %F.  |
| MOD | float a, float b | Preforms a modulo on a and b and puts the result in %F.  |
| AND | int a, and b | Preforms a AND on a and b and puts the result in %A.  |
| OR | int a, and b | Preforms a OR on a and b and puts the result in %A.  |
| XOR | int a, and b | Preforms a XOR on a and b and puts the result in %A.  |
| NOT | int a | Inverts a and puts the result in %A.  |
| CP | any a, register b | Copies a into b.  |
| MOV | any a, register b | Moves a into b.  |
| CMP | any a, any b | Subtracts b from a, and only sets the flags, effectively comparing them .  |
| JMP | code* addr | Sets IP to addr.  |
| JG | code* addr | Sets IP to addr if the negative flag is off.  |
| JLT | code* addr | Sets IP to addr if the negative flag is on.  |
| JZ | code* addr | Sets IP to addr if the zero flag is on.  |
| JNZ | code* addr | Sets IP to addr if the zero flag is off.  |
| READ | any* addr, register a | Reads a byte in memory at addr, and moves it to a.  |
| WRITE | any data, any* addr | Writes data to addr. |
| PUSH | any a | Pushes a onto the stack.  |
| POP | register a | Pops the last element of the stack into a.  |
| CALL | function* fun | Jumps to the function.  |
| RET |  | Returns from a function to its caller.  |
| INC | int a | Increments a by 1.  |
| INCF | float a | Increments a by 1.  |
| DEC | int a | Decrements a by 1.  |
| DECF | float a | Decrements a by 1.  |
| SETERRADDR | code* addr | Sets the address that is jumped to if a error happens.  |
| SYS | int systemcall, any[] ...args | Preforms system call number systemcall, passing in args for arguments. Args is a variable length parameter list. See syscalls.md for details.  |
| BP |  | Pauses execution and starts the debugger.  |
| EXIT | | Exits the program. |

## Usage
For examples on the standard library, see `/test/`. But an example program is presented below.You are recommended to use the `syscalls.h` file in the `/test/` directory, to be able to use named functions for the syscalls.

Example:
```
#include "syscalls.h";
#define helloString "Hello there, ";
#define NAME "John Doe";
sys mem.malloc 22,%B,%C;
sys str.join &helloString, &NAME, %B;
sys sys.printString %B;
sys mem.free %C;
exit;
```

This program demonstrates some of the capabilities of the compiler and interpreter, and serves as a basic hello world program. It should print `Hello there, John Doe`. Feel free to mess around with it to familiarize yourself with the syntax.

## Building

Atto-24 is written in D, and as such, if you don't have one, install a D compiler from [www.dlang.org](https://www.dlang.org/install). Then, if it's not bundled with your D compiler, install DUB, and run `dub build`, to generate a executable. Then simply run `atto24 --src ./path/to/your/file/here`, and voila, it's built!

