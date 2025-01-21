#include <stdlib>;
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
sys io.printStr %B;
sys io.printNum %F;
sys io.printASCII 10;
pop %B;
pop %A;
pop %F;
ret;