jmp 17;
72,101,108,108,111,32,87,111,114,108,100,33,10,0;
32,0;
mov 55,%D
sys 22,2,16,%D;
add %D,%C
mov %A,%D
sys 2,%D;
sys 17,%D,%C
add 1,%D
mov %A,%D
sys 1,10;
jmp 25;