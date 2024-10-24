setErrAddr Error;
mov 5,5;
exit;
Error:
sys 2,String;
String:
"Error!";