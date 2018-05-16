%% 
% systhesis use Karplus-Strong
%%
fs = 44100;     % sample rate
p = 32;        % buffer size  pitch at fs/(p+1/2)= 44100/512.5=86.05Hz

% init 1 second sample
y = zeros(fs,1);

% set 1st buffer as random
for i =1:p+1
    y(i) = rand();
end

% Karplus-Strong
for i = p+2:fs
  y(i) = (y(i-p) + y(i-p-1)) / 2; 
end

s1 = call_dsp_TimeScope(fs, y);
s2 = call_dsp_SpectrumAnalyzer(fs,y);
s3 = call_play_sound(fs,y);


%% 
% 
% 
% common functions
%%
function scope = call_dsp_TimeScope(fs, y)
    scope = dsp.TimeScope('SampleRate',fs,'TimeSpan',1);
    hide(scope);
    scope(y);
    show(scope);
    release(scope);
end

function scope = call_dsp_SpectrumAnalyzer(fs, y)
    scope = dsp.SpectrumAnalyzer('SpectrumType','RMS', 'SampleRate', fs, 'PlotAsTwoSidedSpectrum',false);
    hide(scope);
    scope(y);
    show(scope);
    release(scope);
end

function player = call_play_sound(fs,y)
    player = audioDeviceWriter(fs);
    player(y);
    release(player);
end