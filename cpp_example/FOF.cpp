// FOF.c

#include "stdafx.h"
#include <stdio.h>
#include <stdlib.h>
#define _USE_MATH_DEFINES
#include <math.h>

/*
 FOF	Formant wave functions: Forme d'Onde Formantique
 Cf		Center frenquency in Hz
 BW		Bandwidth in Hz
 A		Amplitude
 Atk	��/B	Skirt width, that is, attack time in second
 fs		Sampling frequency in Hz
 Np		Number of data in points(=fs* second)
 Iphase	Initial phase ��
 */

int FOF(double *s, double Cf, double BW, double A, double Atk, double Iphase, int fs, int Np) {
	double Beta, Alpha, Omegac, pipBeta, fsd, t, cons, pi, max;
	int i;
	pi = M_PI;
	fsd = (double)fs;
	Beta = pi / Atk;
	Alpha = BW * pi;
	Omegac = 2. * pi*Cf;
	pipBeta = floor(Atk*fs);	// the number of points for attack
	max = 0.;
	for (i = 0; i <= pipBeta; i++) {
		t = (double)i / fsd;
		if ((s[i] = 0.5*(1. - cos(Beta*t))*exp(-Alpha * t)*sin(Omegac*t + Iphase)) > max)
			max = s[i];
	}
	for (i = pipBeta + 1; i < Np; i++) {
		t = (double)i / fsd;
		s[i] = exp(-Alpha * t)*sin(Omegac*t + Iphase);
		if ((s[i] = exp(-Alpha * t)*sin(Omegac*t + Iphase)) > max)
			max = s[i];
	}
	cons = A / max;
	for (i = 0; i < Np; i++){
		s[i] *= cons;
		//if (i < 20) printf("s[%i]=%lf ", i, s[i]);
		//if(isnan(s[i])) printf("s[%i]=%lf ", i, s[i]);
	}
	//printf("\n");

	return 0;
}