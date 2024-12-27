#include "syscalls.h";
#define array2 [17,16,15,14,13,12,11,10,9,8,7,6,5,4,3,2,1];
sys array.dynamic.new 17,%B;
sys array.getBody %B,%A;
inc %A;
