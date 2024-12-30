#include "../syscalls.h";
print:
push %F;
push %A;
push %B;
sub %SBP,3;
mov %A,%SBP;
pop %F;
pop %B;
add 3,%SBP;
mov %A,%SBP;
sys sys.printString %B;
sys sys.printNum %F;
sys sys.printAscii 10;
pop %B;
pop %A;
pop %F;
ret;