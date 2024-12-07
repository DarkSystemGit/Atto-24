import std;
import data;
string printOpcode(real opcode) {
    switch (cast(int)opcode) {
        case 0:
    return "NOP";
    break;
    case 1:
    return "ADD";
    break;
    case 2:
    return "SUB";
        break;
        case 3:
        return "MUL";
        break;
        case 4:
        return "ADDF";
        break;
        case 5:
        return "SUBF";
        break;
        case 6:
        return "MULF";
        break;
        case 7:
        return "AND";
        break;
        case 8:
        return "NOT";
        break;
        case 9:
        return "OR";
        break;
        case 10:
        return "XOR";
        break;
        case 11:
        return "CP";
        break;
        case 12:
        return "JMP";
        break;
        case 13:
        return "JNZ";
        break;
        case 14:
        return "JZ";
        break;
        case 15:
        return "CMP";
        break;
        case 16:
        return "SYS";
        break;
        case 17:
        return "READ";
        break;
        case 18:
        return "WRITE";
        break;
        case 19:
        return "PUSH";
        break;
        case 20:
        return "POP";
        break;
        case 21:
        return "MOV";
        break;
        case 22:
        return "CALL";
        break;
        case 23:
        return "RET";
        break;
        case 24:
        return "INC";
        break;
        case 25:
        return "DEC";
        break;
        case 26:
        return "SETERRADDR";
        case 27:
        return "EXIT";
        case 28:
        return "DIV";
        case 29:
        return "MOD";
        case 30:
        return "BREAKPOINT";
        case 31:
        return "JG";
        case 32:
        return "JNG";
        default:
        return "UNKNOWN";
        break;}

}
string printParams(real[] params) {
    string[] res = new string[params.length];
    for (int i = 0; i < params.length; i++) {

        if((-1*(params[i]-(cast(real)4294967296)))>0) {
            res[i] = printRegister(-1*(params[i]-(cast(real)4294967296)));
            if(res[i]=="UNKNOWN") res[i] = params[i].to!string;
        }else{
            res[i] = params[i].to!string;
        }
    }
    return res.join(", ");
}


string printRegister(real id) {
    switch (cast(int)id) {
        case 9:
        return "A";
        break;
        case 8:
        return "B";
        break;
        case 7:
        return "C";
            break;
            case 6:
            return "D";
            break;
            case 5:
            return "E";
            break;
            case 4:
            return "F";
            break;
            case 3:
            return "G";
            break;
            case 2:
            return "H";
            break;
            case 1:
            return "I";
            break;
            case 0:
            return "J";
            break;
            default:
            return "UNKNOWN";
            break;
            }
}
