#include <stdlib>;
#define helloString "Hello there, ";
#define NAME "John Doe";
#define tidstr "TID: ";
#define ustr "Updated: ";
cmp %D,1;
jnz rest;
sys io.printStr &ustr;
sys io.printASCII 10;
rest:
sys mem.malloc 22,%B,%C;
sys str.join &helloString, &NAME, %B;
sys io.printStr %B;
sys io.printASCII 10;
sys mem.free %C;
sys thread.getId %A;
sys io.printStr &tidstr;
sys io.printNum %A;
exit;