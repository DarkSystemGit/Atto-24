#include "syscalls.h";
#define titleStr "Test";
#define errStr "Error";
setErrAddr Error;
sys gfx.getVRAMBuffer %C,%B;
sys gfx.new &titleStr,%C;
push %C;
sys mem.malloc 256,%E,%B;
sys mem.fill %E,255,4;
sys gfx.sprite.new %B,1,1,0,%E;
mov %B,%E;
pop %C;

GameLoop:
sys gfx.windowClosed %A;
cmp 1,%A;
jz CleanUp;
sys mem.fill %C,76800,5;
//bp;
push %F;
addf %G,0.08;
mov %F,%G;
add %E,1;
read %A,%A;
div %A,8;
mov %F,%A;
cmp %A,24;
jlt slip;
mov -0.005,%G;

slip:
pop %F;
cmp %F,1.5;
jg corrF;
cmp %F,0;
jg subF;
glr:
push %F;
read %E,%A;
sys sys.printNum %A;
sys sys.printAscii 32;
sys sys.printNum %F;
sys sys.printAscii 10;
addf %A,%F;
mov %F,%H;
write %H,%E;
pop %F;

add %E,1;
read %A,%A;
add %A,%G;
mov %A,%D;
add %E,1;
write %D,%A;

sys gfx.getPressedKeys %B;
call HandleKeys;
sys gfx.sprite.render %E;
sys gfx.render;
jmp GameLoop;

Error:
bp;
sys sys.printString &errStr;
pop %A;
sys sys.printNum %A;
exit;

CleanUp:
sys gfx.sprite.free %E;
exit;

HandleKeys:
push %A;
push %C;
push %D;
push %E;
read %B,%A;
cmp %A,0;
jz Ret;
mov %A,%C;
mov 0,%D;

Loop:
cmp %D,%C;
jz Ret;
add %B,%D;
inc %A;
read %A,%A;
mov %A,%E;
call handleKey;
inc %D;
jmp Loop;

Ret:
pop %E;
pop %D;
pop %C;
pop %A;
ret;

handleKey:
cmp %E,1;
jnz key2;
push %F;
subf %G,0.1;
mov %F,%G;
pop %F;
key2:
cmp %E,2;
jnz key3;
addf %F,-0.1;
key3:
cmp %E,4;
jnz eof;
cmp %F,1;
//jg eof;
addf %F,0.1;
eof:
ret;

corrF:
mov 1,%F;

subF:
addf -0.009,%F;
cmp %F,0;
jlt zeroF;
jmp glr;

zeroF:
mov 0,%F;
jmp glr;