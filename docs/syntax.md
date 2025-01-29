# Syntax Guide

## Syntax

Atto-24 lets users program in a minimal RISC assembly language, enticing nostalgia for assembly. But we here at Atto Labs aren't evil, so we added a little sugar, to distract you from the pain.

The syntax is as following:


| Type      | Usage                        | Description                                                                                                                                                                                                                                                                                                                                                                                                                                                  |
| --------- | ---------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ |
| Defines   | `#define` `name ` `value`    | Defines a constant value, which can be any type (String, Number, and Bools). Multi-byte values like strings should be refereed to by the address of operator, as such`&name`. This will add the value to the programs data section and replace `&name` with the address in the data section. Simply referring to a value by name substitutes it in place.                                                                                                    |
| Labels    | `Name:`                      | Labels can be used to begin blocks of code, and when the name of a label is used in code, it will replace the name with the address of the block.                                                                                                                                                                                                                                                                                                            |
| Commands  | `command` `operand, operand` | Commands provide instructions for the CPU to execute, they are simply the name of the command, followed by a comma separated list of operands. Different commands may take different amounts of operands, and different amounts of time to execute.                                                                                                                                                                                                          |
| Registers | `%register`                  | A register is a small area of memory used to hold numbers and single byte values for access. There are 10 different registers, from A-J. Different registers may have different types, with A-E being ints, F and G being floats, and H, I, and J being doubles. There's also 2 stack variables, %SBP, and %SP. %SP points to the very top of the stack, being the "Stack Pointer". %SBP points to the base of the stack, where all stack operations happen. |

Atto's assembly language also allows for imports in two different forms.
Local files, `#include "path/to/file"`, or global imports, in the form of `#include <importName>`. Currently, the only supported global import is for the standard library, which can be referred to as `stdlib`.
Atto works off `doubles` being the smallest individual unit, unlike bytes.

## Commands

A listing of available commands are below.


| Name       | Operands                      | Description                                                                                                                                    |
| ---------- | ----------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------- |
| NOP        |                               | Does nothing                                                                                                                                   |
| ADD        | int a, int b                  | Adds a and b and puts the sum in %A.                                                                                                           |
| ADDF       | float a, float b              | Adds a and b and puts the sum in %F.                                                                                                           |
| SUB        | int a, int b                  | Subtracts b from a and puts the result in %A.                                                                                                  |
| MUL        | int a, int b                  | Multiplies a and b and puts the result in %A.                                                                                                  |
| MULF       | float a, float b              | Multiplies a and b and puts the result in %F.                                                                                                  |
| DIV        | float a, float b              | Divides a and b and puts the result in %F.                                                                                                     |
| MOD        | float a, float b              | Preforms a modulo on a and b and puts the result in %F.                                                                                        |
| AND        | int a, and b                  | Preforms a AND on a and b and puts the result in %A.                                                                                           |
| OR         | int a, and b                  | Preforms a OR on a and b and puts the result in %A.                                                                                            |
| XOR        | int a, and b                  | Preforms a XOR on a and b and puts the result in %A.                                                                                           |
| NOT        | int a                         | Inverts a and puts the result in %A.                                                                                                           |
| CP         | any a, register b             | Copies a into b.                                                                                                                               |
| MOV        | any a, register b             | Moves a into b.                                                                                                                                |
| CMP        | any a, any b                  | Subtracts b from a, and only sets the flags, effectively comparing them .                                                                      |
| JMP        | code\* addr                   | Sets IP to addr.                                                                                                                               |
| JG         | code\* addr                   | Sets IP to addr if the negative flag is off.                                                                                                   |
| JLT        | code\* addr                   | Sets IP to addr if the negative flag is on.                                                                                                    |
| JZ         | code\* addr                   | Sets IP to addr if the zero flag is on.                                                                                                        |
| JNZ        | code\* addr                   | Sets IP to addr if the zero flag is off.                                                                                                       |
| READ       | any\* addr, register a        | Reads a byte in memory at addr, and moves it to a.                                                                                             |
| WRITE      | any data, any\* addr          | Writes data to addr.                                                                                                                           |
| PUSH       | any a                         | Pushes a onto the stack.                                                                                                                       |
| POP        | register a                    | Pops the last element of the stack into a.                                                                                                     |
| CALL       | function\* fun                | Jumps to the function.                                                                                                                         |
| RET        |                               | Returns from a function to its caller.                                                                                                         |
| INC        | int a                         | Increments a by 1.                                                                                                                             |
| INCF       | float a                       | Increments a by 1.                                                                                                                             |
| DEC        | int a                         | Decrements a by 1.                                                                                                                             |
| DECF       | float a                       | Decrements a by 1.                                                                                                                             |
| SETERRADDR | code\* addr                   | Sets the address that is jumped to if a error happens.                                                                                         |
| SYS        | int systemcall, any[] ...args | Preforms system call number system call, passing in args for arguments. Args is a variable length parameter list. See syscalls.md for details. |
| BP         |                               | Pauses execution and starts the debugger.                                                                                                      |
| EXIT       |                               | Exits the program.                                                                                                            |
| INT        | int interrupt| Jumps to the interrupt handler for interrupt.                                                                                                       |