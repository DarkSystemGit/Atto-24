#include <stdlib>;
#include "loadProg.asm";
#define fileName "threadsrc.bytecode";
#define split "---------------------------------------------------------------------------";
push &fileName;
call loadProg;
sys thread.dump;
sys thread.remove 1;
sys sys.printString &split;
sys sys.printAscii 10;
sys thread.dump;