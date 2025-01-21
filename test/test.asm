#include <stdlib>;
#define helloString "Hello there, ";
#define NAME "John Doe";
sys mem.malloc 22,%B,%C;
sys str.join &helloString, &NAME, %B;
sys io.printStr %B;
sys mem.free %C;
exit;