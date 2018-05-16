%% 
% FM synthsis
% 
% 

fs = 44100;     % sample rate
fc = 10000;     % carriy rate
fm = 100;       % moderate rate
I = 2;          % fm deep
N = 44100;      % frame count

y=zeros(N,1);   % fm
z=zeros(N,1);   % am
for n=1:N
    y(n) = sin(2*pi*fc*n/fs + I*sin(2*pi*fm*n/fs));
    z(n) = sin(2*pi*fc*n/fs) * sin(2*pi*fm*n/fs);
end

scope = dsp.TimeScope('SampleRate',fs,'NumInputPorts',2);
hide(scope);
scope(y,z);
show(scope);
release(scope);

spa = dsp.SpectrumAnalyzer('SpectrumType','RMS', 'SampleRate', fs, 'PlotAsTwoSidedSpectrum',false, 'NumInputPorts',2,'FrequencyOffset',9500);
hide(spa);
spa(y,z);
show(spa);
release(spa)

%% 
%