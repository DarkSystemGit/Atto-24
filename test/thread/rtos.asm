#include <thread>;
#include <io>;
#include <str>;
#include "loadProg.asm";
#define progs [4,"rtosProgs/concat.bytecode","rtosProgs/platformer.bytecode","rtosProgs/gfx.bytecode","rtosProgs/pong.bytecode"];
//#define repProg [12,0];
sys thread.setInterrupt 2,ent;
mov 1,%E;
mov 0,%C;
mov 1,%D;
//sys thread.create 2,&repProg;
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
mov 0,%B;
inc %E;
read &progs,%A;
inc %A;
cmp %E,%A;
jg ex;
sys thread.switch %E;
jmp main;
ex:
exit;

ent:
cmp %B,1;
jz main;
mov 1,%B;
sys gfx.fillVRAM 2,320,240,0,0;
sys gfx.render;
