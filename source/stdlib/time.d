import std.datetime;
import data;
import registers;
import utils;
struct Time
{
    SysTime time;
    TimeZone offset=LocalTime;
    int id;
    void addTime(Time t){
        this.setStdTime(getStdTime() + t.getStdTime());
    }
    void subTime(Time t)
    {
        this.setStdTime(getStdTime() - t.getStdTime());
    }
    void setUTCoffset(int offset){
        this.offset=new SimpleTimeZone(dur!"hours"(offset));
        time.timezone=offset;
    }
    auto getUTCOffset(){
        return offset.units;
    }    
    void setTime(int hr, int min, int sec)
    {
        time.hour = hr;
        time.minute = min;
        time.second = sec;
    }

    int[] getTime()
    {
        return [time.hour, time.minute, time.second];
    }

    int[] setCurrTime()
    {
        time=Clock.currTime(offset);
    }

    long getUnixTime(){
        return time.toUnixTime();
    }
    void setUnixTime(int unixTime){
        time.fromUnixTime(unixTime,offset);
    }
    long getStdTime()
    {
        return time.stdTime();
    }
    void setStdTime(long stdTime){
        time.stdTime=stdTime;
    }
    int[] getDate(){
        return [time.month, time.day, time.year];
    }
    void setDate(int[] date){
        time.month=date[0];
        time.day=date[1];
        time.year=date[2];
    }
}
Time getTime(int id,ref Machine m){
    return m.objs.times[id];
}
int newTime(ref Machine m,real[] p){
    setRegister(m,(cast(real)4294967296)-p[0],m.objs.addTime(new Time));
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
    setRegister(m,t.getStdTime(),p[0]);
    return 1;
} 
int getUnixTime(ref Machine m,real[] p){
    real[] params=handleRegisters(m,p,1);
    Time t=getTime(cast(int)params[0],m);
    setRegister(m,t.getUnixTime(),p[0]);
    return 1;
}
int getTime(ref Machine m,real[] p){
    real[] params=handleRegisters(m,p,1);
    Time t=getTime(cast(int)params[0],m);   
    setRegister(m,t.getTime(),p[0]);
    return 1;
}
int getDate(ref Machine m,real[] p){
    real[] params=handleRegisters(m,p,1);
    Time t=getTime(cast(int)params[0],m);
    setRegister(m,t.getDate(),p[0]);
    return 1;
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
    setRegister(m,t.getUTCOffset(),p[0]);
    return 1;
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
