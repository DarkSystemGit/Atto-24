import std.random;
import utils;
import std.stdio;
import data;
import registers;
struct Random{
    int seed;
    Distrubution dist;
    Mt19937_64 randGen;
    int id;
    real sample(){
        return dist.sample(randGen);
    }
    this(int id){this.id=id;}
    void initMain(int seed){
        this.seed=seed;
        randGen.seed(seed);
    }
    void setSeed(int seed){
        this.seed=seed;
        randGen.seed(seed);
    }
    void setDistrubution(Distrubution dist){this.dist=dist;}
}
struct Distrubution{
    int min;
    int max;
    real[] values;
    bool inited;
    int id;
    this(int id){this.id=id;}
    real sample(Mt19937_64 randGen){
        if(values.length==0){
            return cast(real)randGen.uniform(min,max,randGen);
        }else if(!inited){
            return randGen.uniform01!real;
        }else if(values.length>0){
            return randGen.dice(values);
        }
        return 0;
    }
    void setProbibities(real[] probs){
        this.inited=true;
        this.values=probs;
        this.min=0;
        this.max=0;
    }
    void setUniforms(int min,int max){
        this.min=min;
        this.max=max;
        this.values=[];
        this.inited=true;
    }
}
int newRandom(ref Machine m,real[] p){
    real[] params=handleRegisters(m,p,1);
    int id=m.objs.addRandom();
    m.objs.rands[id].initMain(cast(int)params[0]);
    setRegister(m,(cast(real)4294967296)-p[1],id);
    return 2;
}
int newDistrubution(ref Machine m,real[] p){
    setRegister(m,(cast(real)4294967296)-p[0],m.objs.addDistrubution());
    return 1;
}