#include <vector>
#include <stdio.h>
#include <math.h>
#define PI 3.14159265
using namespace std;


// sampling
// f		sampling対象関数
// from, to	xの範囲
// rate		sampling rate
// sec  	継続時間
std::vector<double> sample(double from, double to, int rate, double sec, double (*f)(double)){
	double step = (to - from) / sec / rate;
	int cnt = sec * rate;
	std::vector<double> v(cnt);
	for(int i=0; i<cnt; i++){
		double x = from + step * i;
		v[i] = f(x);
		//printf("v[%i]=sin(%f)=%f\n", i, x, v[i]);
	}
	return v;
}

// 8bit変換
std::vector<char> deep8(std::vector<double> v){
	int cnt = v.size();
	std::vector<char> ret(cnt);
	for(int i=0; i<cnt; i++){
		ret[i] = (char)(v[i]*127);
	}
	return ret;
};
// 16bit変換
std::vector<unsigned char> deep16(std::vector<double> v){
	int cnt = v.size();
	std::vector<unsigned char> ret(cnt*2);
	for(int i=0; i<cnt; i++){
		ret[i*2  ] = (char)(v[i]*32767.0f);			// small endian
		ret[i*2+1] = (char)(v[i]*32767.0f/256.0f);
		//printf("ret[%i]=%i, ret[%i]=%i, v[%i]*10000=%f, ret[%i]*256+ret[%i]=%i\n", i*2, ret[i*2], i*2+1, ret[i*2+1], i, v[i], i*2, i*2+1, ret[i*2]*256+ret[i*2+1]);
	}
	return ret;
};
// まとめ関数
void go2(){
	int sec  = 1;		// sound length in second
	int hz   = 1000;	// sound Hz
	int rate = 44100; 	// sample rate

	std::vector<double> v = sample(0.0f, 2.0*PI*hz, rate, sec, sin);
	//std::vector<char> vc = deep8(v);
	std::vector<unsigned char> vc = deep16(v);
	for(int i=0;i<vc.size();i++){
		//printf("vc[%i]=%i, vc[%i]=%i, y=%x\n", i, vc[i], i+1, vc[i+1], vc[i]*256+vc[i+1]);i++;
		printf("%c", vc[i]);
	}
}
int main(int argc, char** argv){
	go2();
}
