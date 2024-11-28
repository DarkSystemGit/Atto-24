#include "syscalls.h";
#define titleStr "Test";
#define errStr "Error";
setErrAddr Error;
sys gfx.getVRAMBuffer %C,%B;
sys gfx.new &titleStr,%C;
mov 0,%A;
mov 0,%D;
GameLoop:
cmp %A,76799;
jz glb;
inc %A;
add %A,%C;
write 7,%A;
sub %A,%C;
//sys sys.printAscii 10;
//sys sys.printNum %A;
jmp GameLoop;
glb:
//sys 23; 
inc %D;
cmp %D,1000;
jz End;
sys gfx.render;
jmp glb;
Error:
sys sys.printString &errStr;
pop %A;
sys sys.printNum %A;
exit;
End:
sys gfx.free;
exit;