#include "syscalls.h";
#define titleStr "Test";
#define errStr "Error";
setErrAddr Error;
sys gfx.getVRAMBuffer %C,%B;
sys gfx.new &titleStr,%C;
push %C;
push %B;
sys mem.malloc 64,%E,%B;
sys mem.fill %E,63,4;
sys gfx.sprite.new %B,100,100,0,%E;
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
call printKeys;
sys gfx.sprite.render %E;
sys gfx.render;
mov 0,%A;
jmp GameLoop;
Error:
sys sys.printString &errStr;
pop %A;
sys sys.printNum %A;
exit;
End:
sys gfx.sprite.free %E;
exit;
printKeys:
push %A;
push %C;
push %D;
push %E;
mov 0,%A;
mov 0,%C;
mov 0,%D;
mov 0,%E;
LoopStart:
read %B,%A;
cmp %D,%A;
jz EOL;
add %B,%D;
inc %A;
read %A,%A;
sys sys.printAscii 10;
sys sys.printNum %A;
inc %D;
jmp LoopStart;
EOL:
pop %E;
pop %D;
pop %C;
pop %A;
ret 0;