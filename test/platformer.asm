#include "syscalls.h";
#define titleStr "GameTest";
#define errStr "Error";
#define palatte [4,0x000000FF,0xFF0000FF,0xFF00FFFF,0x0000FFFF];
setErrAddr Error;
sys gfx.getVRAMBuffer %C,%B;
sys gfx.new &titleStr,%C;
sys gfx.setPalette &palatte;

push %C;
sys mem.malloc 256,%E,%B;
sys mem.fill %E,255,3;
sys gfx.sprite.new %B,1,1,0,%E;
mov %B,%E;
pop %C;

push %C;
push %A;
push %B;
push %D;
sys mem.malloc 4800,%B,%C;
sys mem.malloc 512,%C,%D;
//Tilelist:%B,Tileset:%C
sys mem.malloc 64,%D,%A;
sys mem.fill %D,32,2;
add %D,32;
sys mem.fill %A,32,3;
add 1,%C;
write %D,%A;
call fillScreen;
sys gfx.tilemap.new %A,0,0,%B,%C,80,60;
sys gfx.tilemap.render %A;
mov %A,%I;
pop %D;
pop %B;
pop %A;
pop %C;


GameLoop:
sys gfx.windowClosed %A;
cmp 1,%A;
jz CleanUp;
sys mem.fill %C,76800,1;
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
push %F;
read %I,%F;
subf %F,1;
write %F,%I;
sys gfx.tilemap.render %I;
pop %F;
sys gfx.tilemap.blit %I;
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

fillScreen:
push %A;
push %C;
push %D;
push %E;
push %F;
mov -1,%C;
Loop:
//bp;
inc %C;
cmp %C,4800;
jz EoLFS;
div %C,80;
mov %F,%A;
cmp %A,25;
jlt Loop;
cmp %A,30;
jg Loop;
//bp;
add %B,%C;
write 1,%A;
jmp Loop;
/*add %B,2005;
sys mem.fill %A,400,1;*/
EoLFS:
//bp;
pop %F;
pop %E;
pop %D;
pop %C;
pop %A;
ret;