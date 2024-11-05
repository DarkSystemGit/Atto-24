#include "syscalls.h";
#define TEST_STR "Hello world";
#define TEST_NUM 1234;
sys sys.printNum, TEST_NUM;
sys sys.printAscii, 32;
sys sys.printString, &TEST_STR;
exit; 