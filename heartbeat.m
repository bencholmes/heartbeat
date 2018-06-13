%%% HEARTBEAT A MATLAB script to simulate the sound of a heartbeat.

% Author:           Ben Holmes
% Initial Date:     2016/01/16
% Latest Date:      2018/06/13
% Version:          v2.0.0
% License:          CC0

clear;

%% Simulation settings
fs = 44100;         % Sample rate

numBeats = 10;      % number of heartbeats to simulate
tempoBpm = 100;     % bpm

%% Durations and number of samples

% Calculate the duration of one beat and all the beats.
beatDur    = (60/tempoBpm);
totalDur   = beatDur*numBeats;

% Number of samples for respective durations
beatNs     = floor(beatDur*fs);
totalNs    = floor(totalDur*fs);

% Vectors for plotting against
timeVec = (0:totalNs-1)./fs;
frequencyVec = (0:totalNs-1).*(fs/totalNs);

%% Simulate all heartbeats

hbConcatenated = ones(1,totalNs);
hbConcatenatedUnfiltered = ones(1,totalNs);

for nn=1:numBeats
    % Get heartbeats
    [tempFilteredHb, tempUnfilteredHb] = singleHeartBeat(fs, beatDur, tempoBpm);
    
    % Concatenate them
    hbConcatenated((nn-1)*beatNs+1:nn*beatNs) = tempFilteredHb;
    hbConcatenatedUnfiltered((nn-1)*beatNs+1:nn*beatNs) = tempUnfilteredHb;
end

%% Plot and Listen
% figure(1);
% clf;
% plot(timeVec, hbConcatenated, timeVec, hbConcatenatedUnfiltered);
% xlabel('Time (s)'); ylabel('Amplitude');
% legend('Filtered Pulse','Unfiltered Pulse'); title('Heartbeat Waveforms');
% xlim([0 beatDur*0.6])
% 
% set(gcf,'Renderer','painters');
% 
% print(gcf,'./media/heartbeat.png','-dpng','-r512')

% soundsc(hbConcatenated, fs);

%% Export

% Normalise
y = hbConcatenated./max(abs(hbConcatenated));
% Export
audiowrite('heartbeat.wav',y,fs);