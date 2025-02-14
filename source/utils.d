import std.algorithm.iteration : map, filter;
    import std.array : array;
    import std.path : baseName;
    import std.file;
import data;
import registers;
import std;
import thepath;
version(linux){
string installLoc="/etc/atto24";
}
version(OSX){
string installLoc="/etc/atto24";    
}
string[] listdir(string pathname)
{
    return dirEntries(pathname, SpanMode.shallow)
        .filter!(a => a.isFile)
        .map!((return a) => baseName(a.name))
        .array;
}
char[] readString(ref Machine machine, int mempos) {
    char[] str = new char[0];
    bool eol;
    for(int i=0;!eol;i++){
        if(cast(int)machine.currThread.mem[mempos+i]!=0){
            str.length++;
            str[i]=cast(char)cast(int)machine.currThread.mem[mempos+i];
        }else{eol=true;}} 
        if(str[str.length-1]==0)str.length--;  
    return str;
}
void writeString(ref Machine machine, int mempos, char[] str) {
    str.length++;
    str[str.length-1]=cast(char)0;
     for(int i=0;i<str.length;i++){
        int pos=i+mempos;
        if(pos>machine.currThread.mem.length-1)machine.currThread.mem.length=pos+1;
        machine.currThread.mem[pos]=cast(double)str[i];
    }
    machine.currThread.registers.a=cast(int)str.length;
}
void write(ref Machine m,double mempos,int[] data){   
    for(int i=0;i<data.length;i++){
        int pos=i+cast(int)mempos;
        if(pos>m.currThread.mem.length-1)m.currThread.mem.length=pos+1;
        m.currThread.mem[pos]=cast(double)data[i];
    }    
}
void write(ref Machine m,double mempos,double[] data){   
    for(int i=0;i<data.length;i++){
        int pos=i+cast(int)mempos;
        if(pos>m.currThread.mem.length-1)m.currThread.mem.length=pos+1;
        m.currThread.mem[pos]=data[i];
    }    
}
string getSandboxedPath(ref Machine machine,char[] path){
    return Path(cast(string)machine.basepath).join(Path(cast(string)path).normalize.toString).toAbsolute.toString;
}
Path getBasePath(string src){
    return Path(src).parent().toAbsolute;
}
