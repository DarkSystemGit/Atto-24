import interpreter;
import colorize;
import data;
import compiler;
import std;
import utils;
void test(){
string[] files=[
    "math/exp",
    "math/rounding",
    "math/trig",
    "array/pop",
    "array/push",
    "array/slice",
    "array/insert",
    "array/setget",
    "array/concat",
    "array/free",
    "dirs/mkdir",
    "dirs/isDir",
    "dirs/getcwd",
    "files/writefile",
    "files/isFile",
    "files/fileLength",
    "files/readfile",
    "files/writeBin",
    "files/readBin",
    "files/fileLastMod",
    "files/rename",
    "files/removeFile",
    "mem/malloc",
    "mem/memdump",
    "mem/memfill",
    "mem/memcpy",
    "print/print",
    "print/printStr",
    "str/splitstr",
    "str/strcat",
    "str/strlen",
    "str/strcmp",
    "str/strcpy",
    "str/substr",
    "defines",
    "err",
    "random",
    "sleep",
    "test",
    "time",
    "dirs/cd",
    "dirs/rmdir",
    "thread/create",
    "thread/remove",
    "thread/tinfo",
    "thread/threadsrc"
];
string[] fails=[];
string startcwd=std.file.getcwd();
foreach(string file;files){
    chdir(startcwd);
    string path=installLoc~"/test/"~file~".asm";
    writeln("--------------------------------------------------------------------------");
    cwrite("Running test: ".color(fg.light_green));
    cwriteln(file.color(mode.bold));
    Compiler c=new Compiler();
    c.comp(readText(path),path,false);
    Machine m;
    if(!c.err) m=execBytecode(c.bytecode, false,getBasePath(path));
    writeln();
    if(!m.unhandledErr){
        cwriteln("Test Passed".color(fg.light_green).color(mode.bold));
    }else{
        fails~=file;
        cwriteln("Test Failed".color(fg.red).color(mode.bold));
    }
    cwriteln("Test Done".color(mode.bold));
}
if(fails.length==0){
    cwriteln("All Tests Passed".color(fg.light_green).color(mode.bold));
}else{
    cwriteln("Failed Tests:".color(fg.red).color(mode.bold));
    foreach(string test;fails){
        cwriteln(("  "~test).color(mode.bold));
    }
}
return;
}