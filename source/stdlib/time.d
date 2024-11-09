import std.datetime;
import std.stdio;
import data;
import registers;
import utils;
class Time
{
    DateTime time;
    int offset;
    int id;
    this(int id){
        
        this.id=id;
        this.time=DateTime(1,1,1);
        //writeln(LocalTime());
        offset=0;
            }
    void addTime( Time t){
        SysTime temp=cast(SysTime)time;
        temp.stdTime=(getStdTime() + t.getStdTime());
        this.time=cast(DateTime)temp;
    }
    void subTime( Time t)
    {
        SysTime temp=cast(SysTime)time;
        temp.stdTime=(getStdTime() - t.getStdTime());
        this.time=cast(DateTime)temp;
    }
    void setUTCoffset(int offset){
        this.offset=offset;
    }
    auto getUTCOffset(){
        return offset;
    }    
    void setTime(int hr, int min, int sec)
    {
        time.hour = hr;
        time.minute = min;
        time.second = sec;
    }

    int[] getTime()
    {
       
        return [cast(int)time.hour+offset, cast(int)time.minute, cast(int)time.second];
    }

    void setCurrTime()
    {
        time=cast(DateTime)Clock.currTime();
    }

    long getUnixTime(){
        return (cast(SysTime)time).toUnixTime();
    }
    void setUnixTime(int unixTime){
        time=cast(DateTime)(cast(SysTime)time).fromUnixTime(unixTime);
    }
    long getStdTime()
    {
        return (cast(SysTime)time).stdTime();
    }
    void setStdTime(long stdTime){
    SysTime temp=(cast(SysTime)time);
        
        temp.stdTime=stdTime;
        time=cast(DateTime)temp;
    }
    void setGMTtime(){
         time=cast(DateTime)Clock.currTime(UTC());
    }
    int[] getDate(){
        return [time.month, time.day, time.year];
    }
    void setDate(int[] date){
        time.month=cast(Month)date[0];
        time.day=date[1];
        time.year=date[2];
    }
}
 Time getTime(int id,ref Machine m){
    return m.objs.times[id];
}
int newTime(ref Machine m,real[] p){
    setRegister(m,(cast(real)4294967296)-p[0],m.objs.addTime());
    return 1;
}
int setTime(ref Machine m,real[] p){
    real[] params=handleRegisters(m,p,4);
     Time t=getTime(cast(int)params[0],m);
    t.setTime(cast(int)params[1],cast(int)params[2],cast(int)params[3]);
    return 4;
}
int setTimeUnix(ref Machine m,real[] p){
    real[] params=handleRegisters(m,p,2);
     Time t=getTime(cast(int)params[0],m);
    t.setUnixTime(cast(int)params[1]);
    return 2;
}
int setTimeStd(ref Machine m,real[] p){
     real[] params=handleRegisters(m,p,2);
     Time t=getTime(cast(int)params[0],m);
    t.setStdTime(cast(int)params[1]);
    return 2;
}
int getStdTime(ref Machine m,real[] p){
    real[] params=handleRegisters(m,p,1);
     Time t=getTime(cast(int)params[0],m);
    setRegister(m,(cast(real)4294967296)-p[1],t.getStdTime());
    return 2;
} 
int getUnixTime(ref Machine m,real[] p){
    real[] params=handleRegisters(m,p,1);
     Time t=getTime(cast(int)params[0],m);
    setRegister(m,(cast(real)4294967296)-p[1],t.getUnixTime());
    return 2;
}
int getDateTime(ref Machine m,real[] p){
    real[] params=handleRegisters(m,p,2);

     Time t=getTime(cast(int)params[0],m); 
    int[] dt=t.getDate();
    dt~=t.getTime();
    utils.write(m,params[1],dt);
    return 2;
}    
int setDate(ref Machine m,real[] p){
    real[] params=handleRegisters(m,p,4);
     Time t=getTime(cast(int)params[0],m);
    t.setDate([cast(int)params[1],cast(int)params[2],cast(int)params[3]]);
    return 4;
}
int setUTCOffset(ref Machine m,real[] p){
    real[] params=handleRegisters(m,p,2);
     Time t=getTime(cast(int)params[0],m);
    t.setUTCoffset(cast(int)params[1]);
    return 2;
}
int getUTCOffset(ref Machine m,real[] p){
    real[] params=handleRegisters(m,p,1);
     Time t=getTime(cast(int)params[0],m);
    setRegister(m,(cast(real)4294967296)-p[1],t.getUTCOffset());
    return 2;
}
int addTime(ref Machine m,real[] p){
    real[] params=handleRegisters(m,p,2);
     Time t=getTime(cast(int)params[0],m);
     Time t2=getTime(cast(int)params[1],m); 
    t.addTime(t2);
    return 2;
}
int subTime(ref Machine m,real[] p){
    real[] params=handleRegisters(m,p,2);
     Time t=getTime(cast(int)params[0],m);
     Time t2=getTime(cast(int)params[1],m);
    t.subTime(t2);
    return 2;
}
int setTimeToCurrTime(ref Machine m,real[] p){
    real[] params=handleRegisters(m,p,1);
     Time t=getTime(cast(int)params[0],m);
    t.setCurrTime();
    return 1;
}    
int setTimeToGMT(ref Machine m,real[] p){
    real[] params=handleRegisters(m,p,1);
     Time t=getTime(cast(int)params[0],m);
    t.setGMTtime();
    return 1;
}    
int freeTime(ref Machine m,real[] p){
    real[] params=handleRegisters(m,p,1);
    m.objs.times[cast(int)params[0]]=null;
    return 1;
}