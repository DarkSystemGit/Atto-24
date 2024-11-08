import std.random;
import utils;
import std.stdio;
import data;
import registers;
struct random{
    int seed;
    distrubution dist;
    Mt19937_64 randGen;
    real sample(){
        return dist.sample(randGen);
    }
    this(int seed){
        this.seed=seed;
        randGen.seed(seed);
    }
    void setSeed(int seed){
        this.seed=seed;
        randGen.seed(seed);
    }
}
struct distrubution{
    
}