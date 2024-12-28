import interpreter;
import colorize;
import data;
import compiler;
import std;
void test(){
string[] files=[
    "array/pop",
    "array/push",
    "array/slice",
    "dirs/mkdir",
    "dirs/isDir",
    "dirs/getcwd",
    "dirs/rmdir",
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
    "dirs/cd"
];
rmdirRecurse("testdir");
foreach(string file;files){
    string path="test/"~file~".asm";
    writeln("--------------------------------------------------------------------------");
    cwrite("Running test: ".color(fg.light_green));
    cwriteln(file.color(mode.bold));
    Compiler c=new Compiler();
    c.comp(readText(path),path,false);
    if(!c.err) execBytecode(c.bytecode, false);
    writeln();
    cwriteln("Test Done".color(mode.bold));
}
}