import std.datetime;
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
}
Time getTime(int id,ref Machine m){
    return m.objs.times[id];
}