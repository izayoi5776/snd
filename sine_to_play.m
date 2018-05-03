%% 
% mix 2 sine wave then play it

s1=dsp.SineWave('Frequency',10000, 'SampleRate',44100);
s1.SamplesPerFrame = 10000;

s2=dsp.SineWave('Frequency',1000, 'SampleRate', 44100, 'PhaseOffset',pi/7);
s2.SamplesPerFrame = 10000;

player = audioDeviceWriter();
scope = dsp.TimeScope('TimeSpan',1,'SampleRate',44100,'NumInputPorts',3);
spa = dsp.SpectrumAnalyzer('SpectrumType','RMS', 'SampleRate', 44100, 'PlotAsTwoSidedSpectrum',false,'NumInputPorts',3);
%% 
% output
%%

y1=s1();
y2=s2();

scope(y1,y2, y1+y2);
spa(y1,y2, y1+y2);
%player(y1+y2);

%% 
% release

release(scope);
release(spa);
release(player);
release(s1);
%% 
%