jmp Init;
/*Hello World!*/
String:
72,101,108,108,111,32,87,111,114,108,100,33,10;
/* Print loop */
Init:
mov String,%C
Loop:
sys 1,%C
inc %C
sub %C,13 
cmp %A,String
jnz Loop;