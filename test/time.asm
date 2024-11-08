#include "syscalls.h";
#define printStr1 "The time is: ";
//#define printStr2 "UTC offset: ";
sys time.new %B;
sys time.setToCurrent %B;
sys mem.malloc 6,%C,%D;
sys time.getDateTime %B,%C;
push TimeZone;
cp %B,%E;
PrintLoop:
sys sys.printAscii, 10;
sys sys.printString &printStr1;
mov 0,%B;
LoopCondition:
cmp %B,6;
jnz Loop;
pop %B;
jmp %B;
Loop:
add %B,%C;
read %A,%A;
sys sys.printAscii 32;
sys sys.printNum, %A;
inc %B;
jmp LoopCondition;
TimeZone:
//sys sys.printString &printStr2;
sys time.setUTCOffset %E,6;
sys sys.printAscii 10;
sys time.getUTCOffset %E,%A;
sys time.getDateTime %E,%C;
sys sys.printNum, %A;
push Date;
jmp PrintLoop;
Date:
sys time.setUTCOffset %E,0;
sys time.setDate %E,01,22,2012;
sys time.getDateTime %E,%C;
push Time;
jmp PrintLoop;
Time:
sys time.set %E,12,0,0;
sys time.getDateTime %E,%C;
push UnixTime;
jmp PrintLoop;
UnixTime:
sys time.getUnix %E,%A;
sys sys.printAscii 10;
sys sys.printNum, %A;
sys sys.printAscii 10;
sys time.getStd %E,%H;
sys sys.printNum %H;
sys time.setUnix %E,0;
sys time.getDateTime %E,%C;
push Final;
jmp PrintLoop;
Final:
sys time.setStd %E,0;
sys time.getDateTime %E,%C;
push Sub;
jmp PrintLoop;
Sub:
sys time.new %I;
sys time.setUnix %I,0;
sys time.sub %E,%I;
push Add;
sys time.getDateTime %E,%C;
jmp PrintLoop;
Add:
sys time.setUnix %E,0;
sys time.add %E,%I;
sys time.getDateTime %E,%C;
push GMT;
jmp PrintLoop;
GMT:
sys time.setGMT %E;
sys time.getDateTime %E,%C;
push Exit;
jmp PrintLoop;
Exit:
sys mem.free %D;
exit;