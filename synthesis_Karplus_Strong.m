%% 
% systhesis use Karplus-Strong
%%
fs = 44100;     % sample rate
p = 32;        % buffer size  pitch at fs/(p+1/2)= 44100/512.5=86.05Hz

b = 0.5;        % 0.2=>metal, 0.5=>snare, 0.8=>metal
pd = makedist('Uniform');

% init 1 second sample
y = zeros(fs,1);
z = zeros(fs,1);

% set 1st buffer as random
for i =1:p+1
    y(i) = rand();
    z(i) = y(i);
end

% Karplus-Strong
for i = p+2:fs
  y(i) = (y(i-p) + y(i-p-1)) / 2;
  if random(pd) > b
      z(i) = (z(i-p) + z(i-p-1)) / 2;
  else
      z(i) = -1 * (z(i-p) + z(i-p-1)) / 2;
  end
end

s1 = call_dsp_TimeScope(fs, y, z);
s2 = call_dsp_SpectrumAnalyzer(fs,y,z);
%s3 = call_play_sound(fs,y);


%% 
% 
% 
% common functions
%%
function scope = call_dsp_TimeScope(fs, y, z)
    scope = dsp.TimeScope('SampleRate',fs,'TimeSpan',1,'NumInputPorts',2);
    hide(scope);
    scope(y,z);
    show(scope);
    release(scope);
end

function scope = call_dsp_SpectrumAnalyzer(fs, y,z)
    scope = dsp.SpectrumAnalyzer('SpectrumType','RMS', 'SampleRate', fs, 'PlotAsTwoSidedSpectrum',false,'NumInputPorts',2);
    hide(scope);
    scope(y,z);
    show(scope);
    release(scope);
end

function player = call_play_sound(fs,y)
    player = audioDeviceWriter(fs);
    player(y);
    release(player);
end