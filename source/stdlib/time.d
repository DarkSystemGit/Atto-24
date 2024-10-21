import std.datetime;

struct Date
{
    int tzToUTC(string tz){
        
    };
    string UTCToTZ(int utc);
    int[] getDate(int utc){

    };
    int getUTCOffset(TimeZone tz){

    };
}

struct Time
{
    SysTime time;
    void addTime(Time t){
        this.setStdTime(getStdTime() + t.getStdTime());
    }
    void subTime(Time t)
    {
        this.setStdTime(getStdTime() - t.getStdTime());
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
        time=Clock.currTime();
    }

    long getUnixTime(){
        return time.toUnixTime();
    }
    void setUnixTime(int unixTime){
        time.fromUnixTime(unixTime,UTC());
    }
    long getStdTime()
    {
        return time.stdTime();
    }
    void setStdTime(long stdTime){
        time.stdTime=stdTime;
    }
    void setTimeZone(string tz){
        time.timezone = tz;
    }
}
