#include <thread>;
#include <io>;
#include <str>;
#include "loadProg.asm";
#define progs [3,"rtosProgs/gfx.bytecode""rtosProgs/platformer.bytecode","rtosProgs/pong.bytecode"];
//#define repProg [12,0];
sys thread.setInterrupt 2,ent;
mov 0,%E;
mov 0,%C;
mov 1,%D;
sys gfx.new;
sys gfx.savePalette 0;
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
jz ex;
sys thread.switch %E;
jmp main;
ex:
exit;

ent:
sys gfx.savePalette 1;
sys gfx.loadPalette 0;
mov 1,%B;
sys gfx.fillVRAM 2,320,240,0,0;
push %E;
kloopo:
sys gfx.render;
sys gfx.getPressedKeys %E;
read %E,%D;
mov 0,%C;
inc %E;
kloop:
cmp %C,%D;
jz kloopo;
add %C,%E;
read %A,%A;
cmp %A,gfx.keys.x;
jz entmain;
inc %C;
jmp kloop;
entmain:
pop %E;
sys gfx.loadPalette 1;
//bp;
jmp main;