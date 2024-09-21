import std;
import interpreter;

void main(string[] args) { 
    runPrgm("prgm",readText(args[1]),args[2].to!bool);
}
