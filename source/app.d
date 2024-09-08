import std;
import interpreter;

void main() {
    bool eof = false;
    real[] prgm = new real[0];
    while (!eof) {
        write(">");
        string line = readln().strip();
        real res = 0;
        if (line.indexOf("0x") != -1) {
            res = cast(real)chompPrefix(line, "0x").to!uint(16);
        } else if (line.isNumeric()) {
            res =  cast(real)line.to!uint(10);
        } else {
            switch (line) {
            case "%A":
                res = real.max - 9;
                break;
            case "%B":
                res = real.max - 8;
                break;
            case "%C":
                res = real.max - 7;
                break;
            case "%D":
                res = real.max - 6;
                break;
            case "%E":
                res = real.max - 5;
                break;
            case "%F":
                res = real.max - 4;
                break;
            case "%G":
                res = real.max - 3;
                break;
            case "%H":
                res = real.max - 2;
                break;
            case "%I":
                res = real.max - 1;
                break;
            case "%J":
                res = real.max;
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
                res = 26;
                break;
            case "decf":
                res = 27;
                break;
            case "run":
				writeln("Starting program, data:");
				writeln(prgm);
                eof = true;
                break;
            default:
                break;
            }
        }

        

        if(!eof){prgm.length++;prgm[prgm.length - 1] = res;}

    }
    parse(prgm);
}
