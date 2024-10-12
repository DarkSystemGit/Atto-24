jmp 21;

jmp 16;
72,101,108,108,111,32,87,111,114,108,100,33,10,0;
sys 2,2;

sys 24,19,%B,%C;
sys 26,2,%B,19;
add %B,1;
mov %A,%D;
add %B,15;
write %A,%D;
add %B,18;
mov %A,%D;
add %B,2;
write %A,%D;
jmp %B;