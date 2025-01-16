import std;
import interpreter;
import data;
import compiler;
import colorize;
import test;
import utils;
string usageStr="Usage: ./atto24 <source file> [--debug] [--compiler-debug] [--bcoffset <int offset>] [--run-tests] [--write-bytecode]";
void main(string[] argv) { 
    try{
        
        cwrite("Atto-24 ".color(mode.bold));
        cwrite("█".color(mode.bold).color(fg.red));
        cwrite("█".color(mode.bold).color(fg.green));
        cwrite("█".color(mode.bold).color(fg.blue));
        cwriteln(" v1.0.0".color(mode.bold));
    string[string] args;
    args["--src"]="";
    args["--debug"]="false";
    args["--compiler-debug"]="false";
    args["--bcoffset"]="0";
    args["--run-tests"]="";
    args["--write-bytecode"]="false";
    args["--run-bytecode"]="false";
    for(int i=0;i<argv.length;i++) {
        if(["--debug","--run-tests","--compiler-debug","--write-bytecode","--run-bytecode"].canFind(argv[i])){args[argv[i]]="true";}
        else if("--bcoffset"==argv[i]){args[argv[i]]=argv[i+1];}else if(i>0){args["--src"]=argv[i];}
    }
    if(args["--run-tests"]!=""){
        test.test();
        return;
    }
    if(args["--src"]=="") {writefln(usageStr);return;}
    if(args["--run-bytecode"].to!bool==true){
        execBytecode(cast(double[])read(args["--src"]), args["--debug"].to!bool,getBasePath(args["--src"]));
        return;
    }
    Compiler c=new Compiler();
    if(exists(args["--src"])){
        string src=readText(args["--src"]);
        c.comp(src,args["--src"],args["--compiler-debug"].to!bool);
    if(args["--compiler-debug"].to!bool){
    foreach(stmt; c.stmts){
        write(stmt.type," ");
        if(stmt.type==StmtType.COMMAND){
            writeln(stmt.props.cd);

        }else if(stmt.type==StmtType.LABEL_DEF){
            writeln(stmt.props.ld);
        }else if(stmt.type==StmtType.NUM){
            writeln(stmt.props.nd);
        }else if(stmt.type==StmtType.DEFINE){
            writeln(stmt.props.dd);
        }else if(stmt.type==StmtType.STRING){
            writeln(stmt.props.sd);
            }}
        writeln("Defines: ");
        writeln(c.defines);
        writeln("Labels: ");
        writeln(c.labels);
        writeln("Bytecode:");
        foreach (double b; c.bytecode[args["--bcoffset"].to!int..$])
        {
            if(b.isNaN()&&(b.getNaNPayload()!=0))write(b.getNaNPayload(),",");
            else write(b,",");
        }
        writeln();
        writeln("Data Refences:");
        writeln(c.unResolvedData);
        writeln("Imports:");
        writeln(c.importedFiles);
        writeln("Data Section Map:");
        writeln(getDataMap(c));
    }else if(args["--write-bytecode"].to!bool==true){
        string[] p=args["--src"].split(".");
        p.length--;
        std.file.write(p.join(".")~".bytecode",c.bytecode);
    }else{
        if(!c.err)execBytecode(c.bytecode, args["--debug"].to!bool,getBasePath(args["--src"]));
    }
    }else{
        cwrite(("Error: ").color(fg.red).color(mode.bold));
        cwriteln(("No such file, "~args["--src"]).color(mode.bold));
        return;
    }
    }catch(Throwable t){
        writeln(t);
        writefln(usageStr);
    } 

}
int[string] getDataMap(Compiler c){
    int[string] map;
    ulong sum=c.dataPtr;
    foreach (int i,double[] bytes;c.dataSec)
    {
        map[c.dataSecMap[i]]=cast(int)sum;
        sum+=bytes.length;
    }
    return map;
}