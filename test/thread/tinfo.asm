#include <stdlib>;
#include "loadProg.asm";
#define fileName "threadsrc.bytecode";
#define ustr "Updated thread ending state: ";
#define tesstr "Thread ending state: ";
#define split "---------------------------------------------------------------------------";
push &fileName;
call loadProg;
sys thread.switch;
sys sys.printAscii 10;
sys sys.printString &split;
sys sys.printAscii 10;
sys sys.printString &tesstr;
sys sys.printAscii 10;
Lstart:
sys thread.getInfo 1,%B;
mov 0,%C;
Loop:
cmp %C,16;
jz lend;
add %C,%B;
read %A,%A;
sys sys.printNum %A;
sys sys.printAscii 10;
inc %C;
jmp Loop;
lend:
cmp %E,1;
jz ex;
add %B,1;
write 0,%A;
add %B,6;
write 1,%A;
sys sys.printAscii 10;
sys sys.printString &split;
sys sys.printAscii 10;
sys thread.update 1,%B;
sys thread.switch;
mov 1,%E;
sys sys.printAscii 10;
sys sys.printString &split;
sys sys.printAscii 10;
sys sys.printString &ustr;
sys sys.printAscii 10;
jmp Lstart;
ex:
exit;