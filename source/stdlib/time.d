import std.datetime;
struct duration{
    int milliseconds;
    float toSeconds(){
        return milliseconds/1000;
    }
    float toMinutes(){
        return milliseconds/60000;
    }
    float toHours(){
        return milliseconds/3600000;
    }    
    float toDays(){
        return milliseconds/86400000;
    }
    float toWeeks(){
        return milliseconds/604800000;
    }
    float toMonths(){
        return milliseconds/2629800000;
    }    
    float toYears(){
        return milliseconds/31557600000;
    }
    void setSeconds(float val){
        milliseconds=cast(int)(val*1000);
    }    
    void setMinutes(float val){
        milliseconds=cast(int)(val*60000);
    }
    void setHours(float val){
        milliseconds=cast(int)(val*3600000);
    }    
    void setDays(float val){
        milliseconds=cast(int)(val*86400000);
    }
    void setWeeks(float val){
        milliseconds=cast(int)(val*604800000);
    }
    void setMonths(float val){
        milliseconds=cast(int)(val*2629800000);
    }
    void setYears(float val){
        milliseconds=cast(int)(val*31557600000);
    }
}
struct date{
    duration dur;
    int[] getTime(){
        return [dur.getHours(),dur.getMinutes(),dur.getSeconds()];
    }
    int[] getDate(){
        return [dur.getMonths(),dur.getDays(),dur.getYears()];
    }
    int getUnixTime(){
        
    }
    void setTime(int hours,int minutes,int seconds){
        dur.setHours(hours);
        dur.setMinutes(minutes);
        dur.setSeconds(seconds);
    }
    void setDate(int months,int days,int years){
        dur.setMonths(months);
        dur.setDays(days);
        dur.setYears(years);
    }    
    this(){

    }
}