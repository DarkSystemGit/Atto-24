#include <stdlib>;
#include "loadProg.asm";
#define fileName "threadsrc.bytecode";
#define split "---------------------------------------------------------------------------";
push &fileName;
call loadProg;
sys thread.dump;
sys thread.remove 1;
sys io.printStr &split;
sys io.printASCII 10;
sys thread.dump;