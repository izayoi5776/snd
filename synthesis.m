%% 
% 1, read a file
% 
% 2, try synthesis use sine, 
% 
% 3, then check difference
% 
% 4, loop 2~3
% 
% 
% 
% read file

fileName = 'C:\tmp\nihao.wav';
%fileName = 'C:\tmp\16bit44kmono-small-28.wav';
fileReader = dsp.AudioFileReader(fileName);
fileInfo = audioinfo(fileName);
fileReader.SamplesPerFrame = fileInfo.TotalSamples; % read all one time
audioData = fileReader();
release(fileReader);

%t = (0:0.001:10)';
%audioData = sin(2*pi*50*t) + 2*sin(2*pi*120*t);

sampleRate = fileInfo.SampleRate;
%sampleRate = 1000;
totalSamples= fileInfo.TotalSamples;
tSec = totalSamples/sampleRate;
tStep = 1/sampleRate/tSec;
tMax = 1 - tStep;
t = (0:tStep:tMax)';
%% 
% init player and spectrum
%%
sz = 1500; % spectrum count to be used

player = audioDeviceWriter();
spa = dsp.SpectrumAnalyzer('SpectrumType','RMS', 'SampleRate', sampleRate, 'PlotAsTwoSidedSpectrum',false);
spa2 = dsp.SpectrumAnalyzer('SpectrumType','RMS', 'SampleRate', sampleRate, 'PlotAsTwoSidedSpectrum',false,'NumInputPorts',2);
scope = dsp.TimeScope('TimeSpan',tSec,'SampleRate',sampleRate,'NumInputPorts',2);

hide(spa);
hide(spa2);
hide(scope);

%% 
% play
%%
spa(audioData);
%player(audioData);
%% 
% find peak

specTable = getSpectrumData(spa);
y=[specTable.FrequencyVector{1}, specTable.Spectrum{1}];
[E, index] = sortrows(y,2,'descend');
%% 
% find +-1.5Hz from peak
%%
e1 = E(:,1); % freq
e2 = E(:,2); % power

synSound = zeros(totalSamples,1);
while min(size(e1)) > 0
    [sine, e1, e2] = getPeak(e1, e2, t, tSec);
    synSound = synSound + sine;
end

%% 
% systhesis sound use sine
%%
%E(1:10,1) % top 10 peak (Freq)
%sine=dsp.SineWave('Frequency',E(1:sz,1), 'SampleRate',sampleRate,'Amplitude',E(1:sz,2));
%sine.SamplesPerFrame = totalSamples;
%y=sine();
%tm = (0:1/sampleRate:totalSamples/sampleRate)';

%synSound = zeros(size(t));
%for i = 1:sz
%    sine = sin(2*pi*E(i,1)*t) * E(i,2);
%    synSound = synSound + sine;
%end

%plot(Y);
player(synSound);
%sum(E(:,2)) % should be 1, why not?
spa2(audioData, synSound);
scope(audioData, synSound);
%% 
% release

release(player);
%show(spa);
show(spa2);
show(scope);
release(spa);
release(spa2);
release(scope);
%% 
% functions here
%%
function [sine, e1, e2] = getPeak(e1, e2, t, tSec)
    range = 0.1; % +-1%
    peak = e1(1);
    index = find(e1>=peak*(1-range/100) & e1<=peak*(1+range/100));
    sumPower = sum(e2(index));
    e1(index)=[];
    e2(index)=[];
    sine = sin(2 * pi * peak * t * tSec) * sumPower;
end