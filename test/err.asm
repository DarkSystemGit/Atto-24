
#include "syscalls.h";
#define errString "Error at address: ";
setErrAddr Error;
sys 8;
mov 5;
exit;
Error:
sys sys.printString,&errString;
pop %A;
sys sys.printNum %A;