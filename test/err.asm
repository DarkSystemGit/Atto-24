
#include "syscalls.h";
#define errString "Error at address: ";
setErrAddr Error;
sys 64747,39;
nop;
exit;
Error:
sys sys.printString, &errString;
pop %A;
sys sys.printNum %A;
exit;