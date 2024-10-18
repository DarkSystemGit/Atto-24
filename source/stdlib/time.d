import std.datetime;

struct Date
{
    string getTimeZone();

    int tzToUTC(string tz);
    string UTCToTZ(int utc);
    int[] getDate(int utc);
    int getUTCOffset();
}

struct Time
{
    SysTime time;
    void addTime(Time t);
    void subTime(Time t)
    {

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

    int[] setCurrTime(int utc)
    {

    }

    int getUnixTime(){
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
        time.fromStdTime(stdTime);
    }
    void setTimeZone(string tz){
        time.timezone = tz;
    }
}
