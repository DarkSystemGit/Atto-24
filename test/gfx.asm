#include "syscalls.h";
#define errStr "Error";
setErrAddr Error;
sys gfx.getVRAMBuffer %C,%B;
sys gfx.new %C;
push %C;
push %B;
sys mem.malloc 256,%E,%B;
sys mem.fill %E,255,4;
//bp;
sys gfx.sprite.new %B,0,0,0,%E;
//bp;
mov %B,%E;
pop %B;
pop %C;
mov 1,%A;
mov 0,%D;
GameLoop:
cmp %A,76800;
jz glb;
add %A,%C;
write %D,%A;
sub %A,%C;
inc %A;
jmp GameLoop;

glb:
inc %D;
sys gfx.windowClosed %A;
cmp 1,%A;
jz End;
cmp %D,0;
jz GameRest;
//sys mem.free %E;
GameRest:
sys gfx.getPressedKeys %B;
push %C;
mov 1,%C;
call printKeys;
pop %C;
//bp;

sys gfx.sprite.render %E;
sys gfx.render;
mov 0,%A;
jmp GameLoop;

Error:
bp;
sys sys.printString &errStr;
pop %A;
sys sys.printNum %A;
exit;
End:
sys gfx.sprite.free %E;
exit;

printKeys:
push %A;
//push %C;
push %D;
mov 0,%A;
//mov 0,%C;
mov 0,%D;

LoopStart:
read %B,%A;
cmp %D,%A;
jz EOL;
add %B,%D;
inc %A;
read %A,%A;
cmp %C,1;
jz NoPrint;
//sys sys.printAscii 10;
//sys sys.printNum %A;
jmp Inc;

NoPrint:
call useKey;
Inc:
inc %D;
jmp LoopStart;

EOL:
//push %C;
pop %D;
//pop %C;
pop %A;
ret;
useKey:
//bp;
cmp %A,1;
jz up;
cmp %A,3;
jz down;
cmp %A,2;
jz left;
cmp %A,4;
jz right;
cmp %A,5;
jz rot;

EOF:
ret;

up:
call getY;
dec %A;
call setY;
jmp EOF;

rot:
call rotate;
jmp EOF;

down:
call getY;
inc %A;
call setY;
jmp EOF;

left:
call getX;
dec %A;
call setX;
jmp EOF;

right:
call getX;
inc %A;
call setX;
jmp EOF;

getX:
read %E,%A;
ret;

getY:
add 1,%E;
read %A,%A;
ret;

setX:
write %A,%E;
ret;

setY:
mov %A,%C;
add 1,%E;
write %C,%A;
ret;

rotate:
push %D;
mov %A,%C;
add %E,2;
read %A,%A;
add %C,%A;
mov %A,%C;
add 2,%E;
write %C,%A;
pop %D;
ret;