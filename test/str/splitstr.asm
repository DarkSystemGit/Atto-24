jmp 18;
72,101,108,108,111,32,87,111,114,108,100,33,10,0;
32,0;
mov 65,%D
sys 22,2,16,%D;
cmp 65,%D;
jz 34;
sys 1,44;
add %D,%C
mov %A,%D
sys 2,%D;
sys 17,%D,%C
add 1,%D
mov %A,%D
cmp 72,%D
jnz 31;
jmp 78;