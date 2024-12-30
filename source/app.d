import std;
import interpreter;
import data;
import compiler;
import colorize;
import test;
void main(string[] argv) { 
    try{
        writeln("UASM Interpreter v1.0.0");
    string[string] args;
    args["--src"]="";
    args["--debug"]="false";
    args["--compiler-debug"]="false";
    args["--bcoffset"]="0";
    args["--run-tests"]="";
    for(int i=0;i<argv.length;i++) {
        if(["--debug","--run-tests","--compiler-debug"].canFind(argv[i])){args[argv[i]]="true";}
        else if("--bcoffset"==argv[i]){args[argv[i]]=argv[i+1];}else if(i>0){args["--src"]=argv[i];}
    }
    if(args["--run-tests"]!=""){
        test.test();
        return;
    }
    if(args["--src"]=="") {writefln("Usage: ./uasm <source file> [--debug] [--compiler-debug] [--bcoffset <int offset>] [--run-tests]");return;}
        writeln("Compiling...");

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
        foreach (real b; c.bytecode[args["--bcoffset"].to!int..$])
        {
            if(b.isNaN()&&(b.getNaNPayload()!=0))write(b.getNaNPayload(),",");
            else write(b,",");
        }
        writeln();
        writeln("Data Refences:");
        writeln(c.unResolvedData);
    }else{
        if(!c.err)Machine machine = execBytecode(c.bytecode, args["--debug"].to!bool);
    }
    }else{
        cwrite(("Error: ").color(fg.red).color(mode.bold));
        cwriteln(("No such file, "~args["--src"]).color(mode.bold));
        return;
    }
    }catch(Throwable t){
        writeln(t);
        writefln("Usage: ./uasm <source file> [--debug] [--compiler-debug] [--bcoffset <int offset>] [--run-tests]");
    } 

}
