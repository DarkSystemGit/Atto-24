#include <stdlib>;
#include "loadProg.asm";
#define fileName "threadsrc.bytecode";

push &fileName;
call loadProg;
sys thread.dump;
sys thread.switchId 1;