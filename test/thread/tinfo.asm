#include <stdlib>;
#include "loadProg.asm";
#define fileName "threadsrc.bytecode";
#define ustr "Updated thread ending state: ";
#define tesstr "Thread ending state: ";
#define split "---------------------------------------------------------------------------";
push &fileName;
call loadProg;
sys thread.switch;
sys io.printASCII 10;
sys io.printStr &split;
sys io.printASCII 10;
sys io.printStr &tesstr;
sys io.printASCII 10;
Lstart:
sys thread.getInfo 1,%B;
mov 0,%C;
Loop:
cmp %C,16;
jz lend;
add %C,%B;
read %A,%A;
sys io.printNum %A;
sys io.printASCII 10;
inc %C;
jmp Loop;
lend:
cmp %E,1;
jz ex;
add %B,1;
write 0,%A;
add %B,6;
write 1,%A;
sys io.printASCII 10;
sys io.printStr &split;
sys io.printASCII 10;
sys thread.update 1,%B;
sys thread.switch;
mov 1,%E;
sys io.printASCII 10;
sys io.printStr &split;
sys io.printASCII 10;
sys io.printStr &ustr;
sys io.printASCII 10;
jmp Lstart;
ex:
exit;