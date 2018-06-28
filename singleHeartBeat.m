function [heartbeat, unfilteredHeartbeat] = singleHeartBeat(fs, beatDur, tempo)
% SINGLEHEARTBEAT A function to provide a sonically pleasing heartbeat
% sound.

% Author:           Ben Holmes
% Initial Date:     2016/01/16
% Latest Date:      2018/06/13
% Version:          v2.0.0
% License:          CC0

pulseDur   = min(0.15,0.15*beatDur);
beatNs      = floor(beatDur*fs);
pulseNs     = floor(pulseDur*fs);

shortPause  = zeros(1, ceil(0.25*(beatNs - 2*pulseNs)) );
longPause   = zeros(1, floor(0.75*(beatNs - 2*pulseNs)) );

unfilteredHeartbeat = [0.8*singlePulse(pulseNs)...
                       shortPause...
                       1*singlePulse(pulseNs)...
                       longPause];
              
%% Filtering

% Butterworth 3rd order bandpass
[bBut, aBut] = butter(3,[20 140+tempo]/(0.5*fs),'bandpass');

% Peaking filter
[bPeak, aPeak] = iirpeak(110/(fs/2),120/(0.5*fs));

% Filter the pulse to simulate an abdomen
heartbeat = filter(bPeak,aPeak,filter(bBut,aBut,unfilteredHeartbeat));

end

function pulse = singlePulse(pulseNs)
% SINGLEPULSE Simulate a pulse of a heart
%
% In this case it is intended to be one half of a beat... (not a medical
% definition).

%% Calculate each section

% EKG Sections
% P
pLength = floor((0.75 + rand()/2)*pulseNs/9);
pAmp = (0.75 + rand()/2)*0.1;
pVec = pAmp*hann(pLength).';

% PR segment
prLength = floor((0.75 + rand()/2)*pulseNs/8);
prVec = zeros(1,prLength);

% Q
qLength = floor((0.75 + rand()/2)*pulseNs/24);
qAmp = (0.75 + rand()/2)*0.1;
qVec = -qAmp*hann(qLength).';

% R
rLength = floor((0.75 + rand()/2)*pulseNs/6);
rAmp = (0.75 + rand()/2)*1;
rVec = rAmp*hann(rLength).';

% S
sLength = floor((0.75 + rand()/2)*pulseNs/24);
sAmp = (0.75 + rand()/2)*0.3;
sVec = -sAmp*hann(sLength).';

% ST segment
stLength = floor((0.75 + rand()/2)*pulseNs/9);
stVec = zeros(1,stLength);

% T
tLength = floor((0.75 + rand()/2)*pulseNs/9);
tAmp = (0.75 + rand()/2)*0.2;
tVec = tAmp*hann(tLength).';

% U
uLength = floor((0.75 + rand()/2)*pulseNs/11);
uAmp = (0.75 + rand()/2)*0.1;
uVec = uAmp*hann(uLength).';

% Find the total number of samples left after adding together all
% sections.
sumLength = pLength + prLength + qLength + rLength + sLength +...
            stLength + tLength + uLength;

% Remaining number of samples.
remNs = pulseNs - sumLength;

% Silence for the remaining number of samples.
rem = zeros(1,remNs);

pulse = [ pVec prVec  qVec rVec sVec stVec tVec uVec rem ];

end