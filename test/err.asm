
#include <stdlib>;
#define errString "Error at address: ";
setErrAddr Error;
sys 64747,39;
nop;
exit;
Error:
sys io.printStr, &errString;
pop %A;
sys io.printNum %A;
exit;