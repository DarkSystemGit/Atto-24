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
];
string startcwd=std.file.getcwd();
foreach(string file;files){
    chdir(startcwd);
    string path="test/"~file~".asm";
    writeln("--------------------------------------------------------------------------");
    cwrite("Running test: ".color(fg.light_green));
    cwriteln(file.color(mode.bold));
    Compiler c=new Compiler();
    c.comp(readText(path),path,false);
    if(!c.err) execBytecode(c.bytecode, false,getBasePath(path));
    writeln();
    cwriteln("Test Done".color(mode.bold));
}
return;
}