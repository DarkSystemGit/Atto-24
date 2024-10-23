mov 18,%D;
jmp %D;
/*Hello World!*/
72,101,108,108,111,32,87,111,114,108,100,33,10;
/* Print loop */
mov 0,%C;
add %C,5;
read %A,%B;
sys 1,%B;
inc %C;
sub %D,5;
cmp %C,%A;
add %D,3;
jnz %A;