import std.random;
import utils;
import std.stdio;
import data;
import registers;
struct Random{
    int seed;
    Distrubution dist=new Distrubution(-1);
    MinstdRand0 randGen;
    int id;
    double sample(){
        
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
class Distrubution{
    int min;
    int max;
    double[] vals;
    bool used;
    int id;
    this(int id){this.id=id;}
    double sample(MinstdRand0 randGen){
       
        if(!used){
            return cast(double)randGen.uniform!int;
        }else if(this.vals.length==0){
            return cast(double)uniform(min,max,randGen);
        }else if(this.vals.length>0){
            randGen.dice(vals);
            return randGen.dice(vals);
        }
       
        return 0;
    }
    void setProbibities(double[] probs){
        this.used=true;
        this.vals=probs;
        this.min=0;
        this.max=0;
    }
    void setUniforms(int min,int max){
        this.min=min;
        this.max=max;
        this.vals=[];
        this.used=true;
    }
}
Random* getRandom(int id,ref Machine m){
    return &m.currThread.objs.rands[id];
}
Distrubution getDistrubution(int id,ref Machine m){
    return m.currThread.objs.dists[id];
}
int newRandom(ref Machine m,double[] p){
    double[] params=handleRegisters(m,p,1);
    int id=m.currThread.objs.addRandom();
    m.currThread.objs.rands[id].initMain(cast(int)params[0]);
    setRegister(m,p[1],id);
    return 2;
}
int newDistrubution(ref Machine m,double[] p){
    setRegister(m,p[0],m.currThread.objs.addDist());
    return 1;
}
int setRandSeed(ref Machine m,double[] p){
    double[] params=handleRegisters(m,p,2);
    Random* rand=getRandom(cast(int)params[0],m);
    (*rand).setSeed(cast(int)params[1]);
    return 2;
}
int sampleRand(ref Machine m,double[] p){
    double[] params=handleRegisters(m,p,2);
    Random* rand=getRandom(cast(int)params[0],m);
    setRegister(m,p[1],(*rand).sample());
    return 2;
}
int setDistrubution(ref Machine m,double[] p){
    double[] params=handleRegisters(m,p,2);
    Random* rand=getRandom(cast(int)params[0],m);
    Distrubution dist=getDistrubution(cast(int)params[1],m);
    (*rand).setDistrubution(dist);
    return 2;
}
int setDistrubutionProbabilities(ref Machine m,double[] p){
    double[] params=handleRegisters(m,p,2);
    double[] probs=p[2..cast(ulong)params[1]+2];
    Distrubution dist=getDistrubution(cast(int)params[0],m);
    dist.setProbibities(probs);
    return cast(int)(2+params[1]);
}
int setUniformDistrubution(ref Machine m,double[] p){
    double[] params=handleRegisters(m,p,3);
    Distrubution dist=getDistrubution(cast(int)params[0],m);
    dist.setUniforms(cast(int)params[1],cast(int)params[2]);
    return 3;
}
int freeRandom(ref Machine m,double[] p){
    double[] params=handleRegisters(m,p,1);
    m.currThread.objs.rands[cast(int)params[0]]=Random();
    return 1;
}
int freeDistrubution(ref Machine m,double[] p){
    double[] params=handleRegisters(m,p,1);
    m.currThread.objs.dists[cast(int)params[0]]=null;
    return 1;
}    