import std;
import data;
import log;
real[] compile(string src,bool bytecode) {
    string[] source = parseString(src,bytecode);
    real[] prgm = new real[0];
    bool str;
    int[string] labels;
    string[int] unResolvedRefs;
    for (int i = 0; i < source.length; i++) {
        bool e=true;
        string line = source[i];
        real res = 0;
        
        if(str){
            if(line!="\""){
            res=cast(real)((cast(char[])line)[0]);}else{
                str=false;
                res=0;
            }}else if (line.indexOf("0x") != -1) {
            res = cast(real)chompPrefix(line, "0x").to!uint(16);
        } else if (line.isNumeric()) {
            res = cast(real)line.to!uint(10);
         
        } else {
            switch (line) {
            case "%A":
                res = cast(real)4294967296 - 9;
                break;
            case "%B":
                res = cast(real)4294967296 - 8;
                break;
            case "%C":
                res = cast(real)4294967296 - 7;
                break;
            case "%D":
                res = cast(real)4294967296 - 6;
                break;
            case "%E":
                res = cast(real)4294967296 - 5;
                break;
            case "%F":
                res = cast(real)4294967296 - 4;
                break;
            case "%G":
                res = cast(real)4294967296 - 3;
                break;
            case "%H":
                res = cast(real)4294967296 - 2;
                break;
            case "%I":
                res = cast(real)4294967296 - 1;
                break;
            case "%J":
                res = cast(real)4294967296;
                break;
            case "add":
                res = 1;
                break;
            case "sub":
                res = 2;
                break;
            case "mul":
                res = 3;
                break;
            case "addf":
                res = 4;
                break;
            case "subf":
                res = 5;
                break;
            case "mulf":
                res = 6;
                break;
            case "and":
                res = 7;
                break;
            case "not":
                res = 8;
                break;
            case "or":
                res = 9;
                break;
            case "xor":
                res = 10;
                break;
            case "cp":
                res = 11;
                break;
            case "jmp":
                res = 12;
                break;
            case "jnz":
                res = 13;
                break;
            case "jz":
                res = 14;
                break;
            case "cmp":
                res = 15;
                break;
            case "sys":
                res = 16;
                break;
            case "read":
                res = 17;
                break;
            case "write":
                res = 18;
                break;
            case "push":
                res = 19;
                break;
            case "pop":
                res = 20;
                break;
            case "mov":
                res = 21;
                break;
            case "call":
                res = 22;
                break;
            case "ret":
                res = 23;
                break;
            case "inc":
                res = 24;
                break;
            case "dec":
                res = 25;
                break;
            case "incf":
                res = 24;
                break;
            case "decf":
                res = 25;
                break;
            case "setErrAddr":
            res = 26;
            break;
            case "exit":
            res=27;
            break;
            case "true":
            res=1;
            break;
            case "false":
            res=0;
            break;    
            case "\"":
                str=true;
                e=false;
                break;
        
            case "":
                e=false;
                break;

            default:
                if(line.indexOf(":")==line.length-1){
                    string name=line.split(":")[0];
                    int addr=cast(int)prgm.length;
                    labels[name]=addr;
                    
                }else if(labels.keys.canFind(line)){
                    res=labels[line];
                }else{
                    unResolvedRefs[cast(int)prgm.length]=line;
                    e=false;
                }
                
                break;
            }
        }
        if(e){       prgm.length++;
        prgm[prgm.length-1] = res;}

    }
    foreach(int i, string link;unResolvedRefs){
        if(labels.keys.canFind(link)){ 
            prgm[i]=labels[link];
        }
    }
    if(bytecode){writeln("Bytes: ",prgm);writeln("Length: ",prgm.length);}
    return prgm;
}

string[] parseString(string source,bool bytecode) {
    string[] rawSrc=source.strip().replace(',', ";").replace("\n",";").split(";");
    string[] tokens = new string[0];
    foreach (string line;rawSrc) {
        if(line.indexOf("\"")==0||line.indexOf("/*")==0){
            if(line.indexOf("\"")==0){
            tokens ~=line.split("");}
        }else{
            tokens~= line.split(" ");
        }
    }
    if(bytecode)writeln("Tokens: ",tokens);
    return tokens;
}