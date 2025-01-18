#include <stdlib>;
#define helloString "Hello there, ";
#define NAME "John Doe";
#define tidstr "TID: ";
#define ustr "Updated: ";
cmp %D,1;
jnz rest;
sys sys.printString &ustr;
sys sys.printAscii 10;
rest:
sys mem.malloc 22,%B,%C;
sys str.join &helloString, &NAME, %B;
sys sys.printString %B;
sys sys.printAscii 10;
sys mem.free %C;
sys thread.getId %A;
sys sys.printString &tidstr;
sys sys.printNum %A;
exit;