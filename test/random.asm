#include "syscalls.h";
#define str1 "RandInt: ";
#define weights [0.117,0.404,0.2,0.3];
jmp Init;
PrintNum:
sys random.get %A,%C;
sys sys.printString &str1;
sys sys.printNum %C;
sys sys.printAscii 10;
ret;
Init:
sys random.new 44,%A;
sys randomDistrubution.new %B;
call PrintNum;
sys random.setSeed %A,7795;
call PrintNum;
sys time.new %D;
sys time.setToCurrent %D;
sys time.getUnix %D,%E;
sys time.free %D;
sys random.setSeed %A,%E;
sys randomDistrubution.setUniform %B,1,9;
sys random.setDistribution %A,%B;
call PrintNum;
sys randomDistrubution.setProbibilities %B,4,weights;
call PrintNum;
sys random.free %A;
sys randomDistrubution.free %B;
exit;