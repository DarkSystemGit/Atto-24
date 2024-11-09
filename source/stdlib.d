import std;
import core.thread;
import core.time;
import data;
import registers;
import dirs;
import files;
import utils;
import print;
import files;
import str;
import mem;
import time;
import random;
//syscall 8; sleep(int time)
int sleep(ref Machine machine,real[] p) {
    real[] params=handleRegisters(machine, p, 1);
    Thread.sleep(dur!("msecs")(cast(int)params[0]));
    return 1;
}
class sysManager{
int function(ref Machine machine, real[] params)[] syscalls=[
    &print.print,&printASCII,&printStr,&readFile,
    &writeFile,&getFileLength,&getFileLastModified,&removeFile,
    &sleep,&mkdir,&rmdir,&getcwd,
    &cd,&isDir,&isFile,&rename,
    &ls,&strlen,&strcat,&strcpy,
    &strcmp,&substr,&splitstr,&memdump,
    &malloc,&free,&memcopy,&memfill,
    &mem.castval, &newTime, &setTime,&setTimeUnix,
    &setTimeStd,&getStdTime, &getUnixTime, &getDateTime,
    &setDate,&setUTCOffset,&getUTCOffset,&addTime,
    &subTime,&setTimeToCurrTime,&setTimeToGMT,&freeTime,
    &newRandom,&newDistrubution,&setRandSeed,&sampleRand,
    &setDistrubution,&setDistrubutionProbabilities,&setUniformDistrubution,&freeRandom,
    &freeDistrubution 
];
int syscall(ref Machine m, real sys,real[] params) {
    return syscalls[cast(ulong)sys](m,params)+1;
}}