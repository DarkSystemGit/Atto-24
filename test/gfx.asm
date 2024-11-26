#include "syscalls.h";
#define titleStr "Test";
sys gfx.getVRAMBuffer %C,%B;
sys gfx.new &titleStr,%C;
mov 0,%A;
GameLoop:
cmp %A,76800;
jz glb;
inc %A;
add %A,%C;
write 7,%A;
sub %A,%C;
jmp GameLoop;
glb:
mov 76800,%A;   
sys gfx.render;
jmp GameLoop;