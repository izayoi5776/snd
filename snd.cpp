#include <vector>
#include <stdio.h>
#include <math.h>
#define PI 3.14159265
using namespace std;

void go(){
	int sec  = 1;		// sound length in second
	int hz   = 1000;	// sound Hz
	int rate = 8000; 	// sample rate
	int bit  = 16;		// bits 

	double all = hz*2*PI*sec;
	double step = all / sec / rate;
	int half = pow(2, bit) /2 -1;
	//printf("sec=%i hz=%i, rate=%i, all=%f, step=%f, half=%d\n", sec, hz, rate,all,step, half);
	for(double i=0;i<all;i+=step){
		//printf("i=%f, sin(i)=%f\n", i,((1 + sin(i))* 128));
		if(bit==8){
			printf("%c", (unsigned char)((1 + sin(i)) * half));
		}else if(bit==16){
			double s = ((sin(i)) *30000.0);	// sign注意、掛ける32768ならマイナスになる。
			int ch = (unsigned char)(int)(s/256.0);
			int cl = (unsigned char)(int)(s);
			//printf("i=%f, s=%f, int(s)=%d, ch=%d, cl=%d, ch*256+cl=%d\n", i, s, (int)s, ch, cl, ch*256+cl);
			printf("%c%c", ch, cl);
		}
	}
}

// sampling
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

std::vector<char> deep8(std::vector<double> v){
	int cnt = v.size();
	std::vector<char> ret(cnt);
	for(int i=0; i<cnt; i++){
		ret[i] = (char)(v[i]*127);
	}
	return ret;
};
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
void go2(){
	std::vector<double> v = sample(0.0f, 2.0*PI*1000, 44100, 1.0f, sin);
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
