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
import gfx;
import array;
import thread;
import math;
//syscall 8; sleep(int time)
int sleep(ref Machine machine,double[] p) {
    double[] params=handleRegisters(machine, p, 1);
    core.thread.osthread.Thread.sleep(dur!("msecs")(cast(int)params[0]));
    return 1;
}
int nutin(ref Machine machine,double[] p){
    return 0;
}
class sysManager{
int function(ref Machine machine, double[] params)[] syscalls=[
    &print.print,&printASCII,&printStr,&readTextFile,
    &writeTextFile,&getFileLength,&getFileLastModified,&removeFile,
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
    &freeDistrubution,&initGFX,&readVRAM,&freeGFX,
    &renderGFX,&setPalette,&getKeys,&windowClosed,
    &initSprite,&resizeSprite,&scaleSprite,&drawSprite,
    &freeSprite,&initTilemap,&rerenderTilemap,&renderTilemap,
    &setTileInTileset,&freeTilemap,&newStaticArray,&newDynamicArray,
    &getArrayBody,&getArrayCapacity,&getArrayData,&getArrayLength,
    &arrayPush,&arrayPop,&arraySlice,&arraySplice,
    &arrayInsert,&printArray,&arraySet,&arrayGet,
    &arrayConcat,&arrayFreeDynamic,&arrayFreeStatic,
    &mabs,&msqrt,&mcbrt,&mhypot,
    &msin,&mcos,&mtan,&masin,
    &macos,&matan,&mceil,&mfloor,
    &mround,&mint,&mpow,&mlog,
    &mfinite,&readFile,&writeFile,&addThread,
    &nutin,&getThreadID,&removeThread,&dumpThreads,
    &getThreadInfo,&updateThread,&switchThreadId,&setInterrupt,
    &writeVRAM,&copyVRAM,&fillVRAM,&savePalette,
    &loadPalette
];
int syscall(ref Machine m, double sys,double[] params) {
    return syscalls[cast(ulong)sys](m,params)+1;
}}