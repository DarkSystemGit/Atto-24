#include "syscalls.h";
#define str1 "RandInt: ";
jmp Init;
PrintNum:
sys random.get %A,%C;
sys sys.printString &str1;
sys sys.printNum %C;
ret 0;
Init:
sys random.new 44,%A;
sys randomDistrubution.new %B;
call PrintNum,0;
sys random.setSeed %A,5;
call PrintNum;