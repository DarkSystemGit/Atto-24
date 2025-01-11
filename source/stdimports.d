import std.file;
import utils;
string stdImports(string name){
   
    return readText(installLoc~"/includes/"~name~".h");
}