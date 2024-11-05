#include "../syscalls.h";
#define printStr1 "The time is: ";
sys time.new %B;
sys time.setToCurrent %B;
sys mem.malloc 6,%C,%D;
sys time.getDateTime %B,%C;
sys sys.printString &printStr1;
mov 0,%B;
LoopCondition:
cmp %B,6;
jnz Loop;
exit;
Loop:
add %B,%C;
read %A,%A;
sys sys.printNum, %A;
inc %B;
jmp LoopCondition;