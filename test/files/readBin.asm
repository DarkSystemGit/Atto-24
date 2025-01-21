#include <stdlib>;
#define fileName "test.bin";
sys file.getLength &fileName,%A;
sys mem.malloc %A,%B,%C;
sys file.read &fileName,%B,%A;
mov %A,%C;
mov 0,%D;
pLoop:
cmp %D,%C;
jz Exit;
add %D,%B;
read %A,%A;
sys io.printNum %A;
sys io.printASCII 10;
inc %D;
jmp pLoop;
Exit:
sys file.remove &fileName;
exit;