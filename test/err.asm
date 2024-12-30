
#include "syscalls.h";
#define errString "Error at address: ";
setErrAddr Error;
sys 647473;
nop;
exit;

Error:
sys sys.printString, &errString;
sys sys.printAscii 10;
pop %A;
sys sys.printNum %A;
exit;