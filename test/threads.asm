#include <stdlib>;
#define fileName "test.bytecode";
sys file.getLength &fileName,%A;
sys mem.malloc %A,%B,%C;
sys file.read &fileName,%B,%A;
sys thread.create %A,%B;
sys thread.switch;