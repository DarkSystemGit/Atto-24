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
class Distrubution{
    int min;
    int max;
    real[] vals;
    bool used;
    int id;
    this(int id){this.id=id;}
    real sample(MinstdRand0 randGen){
       
        if(!used){
            return cast(real)randGen.uniform!int;
        }else if(this.vals.length==0){
            return cast(real)uniform(min,max,randGen);
        }else if(this.vals.length>0){
            randGen.dice(vals);
            return randGen.dice(vals);
        }
       
        return 0;
    }
    void setProbibities(real[] probs){
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
    return &m.objs.rands[id];
}
Distrubution getDistrubution(int id,ref Machine m){
    return m.objs.dists[id];
}
int newRandom(ref Machine m,real[] p){
    real[] params=handleRegisters(m,p,1);
    int id=m.objs.addRandom();
    m.objs.rands[id].initMain(cast(int)params[0]);
    setRegister(m,p[1],id);
    return 2;
}
int newDistrubution(ref Machine m,real[] p){
    setRegister(m,p[0],m.objs.addDist());
    return 1;
}
int setRandSeed(ref Machine m,real[] p){
    real[] params=handleRegisters(m,p,2);
    Random* rand=getRandom(cast(int)params[0],m);
    (*rand).setSeed(cast(int)params[1]);
    return 2;
}
int sampleRand(ref Machine m,real[] p){
    real[] params=handleRegisters(m,p,2);
    Random* rand=getRandom(cast(int)params[0],m);
    setRegister(m,p[1],(*rand).sample());
    return 2;
}
int setDistrubution(ref Machine m,real[] p){
    real[] params=handleRegisters(m,p,2);
    Random* rand=getRandom(cast(int)params[0],m);
    Distrubution dist=getDistrubution(cast(int)params[1],m);
    (*rand).setDistrubution(dist);
    return 2;
}
int setDistrubutionProbabilities(ref Machine m,real[] p){
    real[] params=handleRegisters(m,p,2);
    real[] probs=p[2..cast(ulong)params[1]+2];
    Distrubution dist=getDistrubution(cast(int)params[0],m);
    dist.setProbibities(probs);
    return cast(int)(2+params[1]);
}
int setUniformDistrubution(ref Machine m,real[] p){
    real[] params=handleRegisters(m,p,3);
    Distrubution dist=getDistrubution(cast(int)params[0],m);
    dist.setUniforms(cast(int)params[1],cast(int)params[2]);
    return 3;
}
int freeRandom(ref Machine m,real[] p){
    real[] params=handleRegisters(m,p,1);
    m.objs.rands[cast(int)params[0]]=Random();
    return 1;
}
int freeDistrubution(ref Machine m,real[] p){
    real[] params=handleRegisters(m,p,1);
    m.objs.dists[cast(int)params[0]]=null;
    return 1;
}    