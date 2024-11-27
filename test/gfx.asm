#include "syscalls.h";
#define titleStr "Test";
#define errStr "Error";
setErrAddr Error;
sys gfx.getVRAMBuffer %C,%B;
sys gfx.new &titleStr,%C;
mov 0,%A;
GameLoop:
cmp %A,76799;
jz glb;
inc %A;
add %A,%C;
write 7,%A;
sub %A,%C;
jmp GameLoop;
glb:
mov 76799,%A;   
sys gfx.render;
jmp GameLoop;
Error:
sys sys.printString &errStr;
sys 23;
exit;