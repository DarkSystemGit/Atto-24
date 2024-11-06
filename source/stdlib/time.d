import std.datetime;
import std.stdio;
import data;
import registers;
import utils;
class Time
{
    SysTime time;
    TimeZone* offset;
    int id;
    this(int id){
        this.id=id;
        this.time=SysTime(DateTime(1,1,1));
        immutable LocalTime l=LocalTime();
        offset=cast(TimeZone*)l;
            }
    void addTime( Time t){
        this.setStdTime(getStdTime() + t.getStdTime());
    }
    void subTime( Time t)
    {
        this.setStdTime(getStdTime() - t.getStdTime());
    }
    void setUTCoffset(int offset){
        this.offset=cast(TimeZone*)new SimpleTimeZone(dur!"hours"(offset));
        time.timezone=cast(immutable TimeZone)*this.offset;
    }
    auto getUTCOffset(){
        return (cast(SimpleTimeZone)*offset).utcOffset.total!"hours";
    }    
    void setTime(int hr, int min, int sec)
    {
        time.hour = hr;
        time.minute = min;
        time.second = sec;
    }

    int[] getTime()
    {
                writeln("BADUM");
        return [cast(int)time.hour, cast(int)time.minute, cast(int)time.second];
    }

    void setCurrTime()
    {
        time=Clock.currTime();
        time.timezone=cast(immutable TimeZone)*this.offset;
    }

    long getUnixTime(){
        return time.toUnixTime();
    }
    void setUnixTime(int unixTime){
        time.fromUnixTime(unixTime,cast(immutable TimeZone)*this.offset);
    }
    long getStdTime()
    {
        return time.stdTime();
    }
    void setStdTime(long stdTime){
        time.stdTime=stdTime;
    }
    int[] getDate(){

        writeln(this.time);
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
    utils.write(m,p[1],dt);
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
