//malloc 20, addr is in B, C is id;
sys 24,20,%B,%C;
sub %B,1;
mov %A,%D;
//memfill, adress=B-1, 20 chars, all A;
sys 27,%D,20,0x41;
//Memory=B-1: 0x41 19 times, 0
write %A,0;
sys 2,%D;
sys 25,%C;
exit;