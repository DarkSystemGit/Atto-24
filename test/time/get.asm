#include "../syscalls.h";
#define printStr1 "The time is: ";
sys time.new %B;
sys time.setToCurrent %B;
sys mem.malloc 6,%C,%D;
sys time.getDateTime %B,%C;
sys sys.printString &printStr1;
push Set;
cp %B,%E;
PrintLoop:
sys sys.printAscii, 10;
mov 0,%B;
LoopCondition:
cmp %B,6;
jnz Loop;
pop %B;
jmp %B;
Loop:
add %B,%C;
read %A,%A;
sys sys.printAscii 32;
sys sys.printNum, %A;
inc %B;
jmp LoopCondition;
Set:
sys time.setUTCOffset %E,6;
push Exit;
jmp PrintLoop;
Exit:
exit;