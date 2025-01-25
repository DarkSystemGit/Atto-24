#include <thread>;
#include <io>;
#include <str>;
#include "loadProg.asm";
#define progs [5,"rtosProgs/concat.bytecode","rtosProgs/splitstr.bytecode","rtosProgs/pong.bytecode","rtosProgs/gfx.bytecode","rtosProgs/platformer.bytecode"];

//sys thread.setInterrupt 0,intH;
mov 0,%E;
mov 0,%C;
mov 1,%D;
Loop:
read &progs,%A;
cmp %C,%A;
jz main;
add &progs,%D;
sys str.len %A,%B;
inc %B;
push %A;
call loadProg;
add %B,%D;
mov %A,%D;
inc %C;
jmp Loop;

main:
inc %E;
cmp %E,6;
jg ex;
sys thread.switch %E;
jmp main;
ex:
exit;