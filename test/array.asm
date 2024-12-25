#include "syscalls.h";
#define array1 [1,2,3];
#define array2 [17,16,15,14,13,12,11,10,9,8,7,6,5,4,3,2,1];
sys array.new 3,%B;
sys array.dynamic.new 17,%C;
sys array.getData %B,%A;
push %A;
call printNum;
sys array.getData %C,%A;
push %A;
call printNum;
bp;
exit;

printNum:
pop %A;
sys sys.printNum %A;
sys.printAscii 10;
ret;