#include <stdlib>;
#define array1 [1,2,3];
#define array2 [17,16,15,14,13,12,11,10,9,8,7,6,5,4,3,2,1];
sys array.dynamic.new 3,%B;
sys array.new 3,%C;
sys array.getBody %B,%A;
push %A;
call printNum;
sys array.getBody %C,%A;
push %A;
call printNum;
sys array.capacity %B,%A;
push %A;
call printNum;
sys array.capacity %C,%A;
push %A;
call printNum;
sys array.data %B,%A;
push %A;
call printNum;
sys array.data %C,%A;
push %A;
call printNum;
sys array.length %B,%A;
push %A;
call printNum;
sys array.length %C,%A;
push %A;
call printNum;
push &array2;
push %B;
push 17;

call pushLoop;

push &array1;
push %C;
push 3;
call pushLoop;
sys array.print %B;
sys array.print %C;
exit;

printNum:
pop %A;
sys sys.printNum %A;
sys sys.printAscii 10;
ret;

pushLoop:
push %A;
push %B;
push %I;
push %E;
sub %SBP,4;
mov %A,%SBP;
pop %E;
pop %B;
pop %I;

add %SBP,4;
mov %A,%SBP;
push %C;
push %D;
mov -1,%C;
Loop:
inc %C;
cmp %C,%E;
jz EOL;
add %C,%I;
read %A,%A;
sys array.push %B,%A;
jmp Loop;
EOL:
pop %D;
pop %C;
pop %E;
pop %I;
pop %B;
pop %A;
ret;
