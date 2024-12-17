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
