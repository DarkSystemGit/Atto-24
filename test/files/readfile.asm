mov 12,%D;
add 10,%D;
mov %A,%D;
jmp %D;
46,47,116,101,115,116,46,116,120,116,0;
mov 51,%D;
sys 3,11,%D,27;
mov 0,%B;
add %D,%B;
read %A,%C;
sys 1,%C;
cmp 26,%B;
inc %B;
jnz 33;
jmp 78;