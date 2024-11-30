#include "syscalls.h";
#define titleStr "Test";
#define errStr "Error";
setErrAddr Error;
sys gfx.getVRAMBuffer %C,%B;
sys gfx.new &titleStr,%C;
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
sys mem.free %E;
GameRest:
sys gfx.pollEvents %B,%E;
call printEvents;
sys gfx.render;
mov 0,%A;
jmp GameLoop;
Error:
sys sys.printString &errStr;
pop %A;
sys sys.printNum %A;
exit;
End:
exit;
printEvents:
bp;
//save state
push %D;
push %C;
push %E;
mov 0,%A;
mov 0,%E;
//gets array length
read %B,%C;
mov 0,%D;
//zero adjusts the length
sub %C,1;
//%E=arr.length,%D=counter,%B=start addr
mov %A,%E;
mov %B,%C;
LoopStart:
//condition checking
cmp %D,%E;
jz EOL;
//gets str len, adds it to current string pos, %C
sys str.len %C,%A;
add %A,%C;
//prints it
sys sys.printString %C;
//movs the new sum to current
mov %A,%C;
//end of loop stuff
inc %D;
jmp LoopStart;
EOL:
//restores state
pop %E;
pop %C;
pop %D;
ret 0;