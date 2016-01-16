%%% HEARTBEAT a script to generate a heartbeat sound effect.
% Author:  Ben Holmes
% Date:    2016/01/09
% License: MIT


clear;
%% Simulation settings
fs = 44100;

num_beats = 1;   % number of heartbeats
tempo = 60;      % bpm

pulse_dur = min(0.15,9/tempo);  % duration of the pulse
total_dur = (60/tempo);         % duration including pause between beats.

pulse_Ns = floor(pulse_dur*fs);
total_Ns = floor(num_beats*total_dur*fs); % sum of number of samples.
t = linspace(0,total_dur,total_Ns);
f = linspace(0,fs,total_Ns);

% Seed the rng
rng('shuffle');

%% Heartbeat sections
% The heartbeat is created from hann windows constructed vaguely into the
% shape of a heartbeat copied from an EKG.

pulse = [];
for n = 1:num_beats*2
    % EKG Sections
    % P
    p_length = floor((0.75 + rand()/2)*pulse_Ns/9);
    p_amp = (0.75 + rand()/2)*0.1;
    P = p_amp*hann(p_length).';
    
    % PR segment
    pr_length = floor((0.75 + rand()/2)*pulse_Ns/8);
    PR = zeros(1,pr_length);
    
    % Q
    q_length = floor((0.75 + rand()/2)*pulse_Ns/24);
    q_amp = (0.75 + rand()/2)*0.1;
    Q = -q_amp*hann(q_length).';
    
    % R
    r_length = floor((0.75 + rand()/2)*pulse_Ns/6);
    r_amp = (0.75 + rand()/2)*1;
    R = r_amp*hann(r_length).';
    
    % S
    s_length = floor((0.75 + rand()/2)*pulse_Ns/24);
    s_amp = (0.75 + rand()/2)*0.3;
    S = -s_amp*hann(s_length).';
    
    % ST segment
    st_length = floor((0.75 + rand()/2)*pulse_Ns/9);
    ST = zeros(1,st_length);
    
    % T
    t_length = floor((0.75 + rand()/2)*pulse_Ns/9);
    t_amp = (0.75 + rand()/2)*0.2;
    T = t_amp*hann(t_length).';
    
    % U
    u_length = floor((0.75 + rand()/2)*pulse_Ns/11);
    u_amp = (0.75 + rand()/2)*0.1;
    U = u_amp*hann(u_length).';
    
    % Find the total number of samples left after adding together all
    % sections.
    sum_length = p_length + pr_length + q_length + r_length + s_length +...
        st_length + t_length + u_length;
    
    % Remaining number of samples.
    rem_ns = pulse_Ns - sum_length;
    
    % Silence for the remaining number of samples.
    rem = zeros(1,rem_ns);
    
    %% Stitch together
    single_pulse = [ P PR  Q R S ST T U rem ];
    
    % A condition to switch between two different lengths between pulses,
    % and apply a gain difference.
    if mod(n,2)
        % 1/4 of the length
        inter_pulse = zeros(1, ceil((((total_dur)*fs) - 2*pulse_Ns)/4) );
        gain = 0.8;
    else
        % 3/4 of the length
        inter_pulse = zeros(1, floor(3*(((total_dur)*fs) - 2*pulse_Ns)/4) );
        gain = 1;
    end
    
    % Stick the pulses together (admittedly in an ugly method).
    pulse = [pulse gain.*[single_pulse inter_pulse]];
    
end

%% Add resonant "abdomen"

% Butterworth 3rd order bandpass
[b_but, a_but] = butter(3,[40 280+(2*tempo)]/fs,'bandpass');
filtered_pulse = filter(b_but,a_but,pulse);

% Peaking filter
[b_peak, a_peak] = iirpeak(110/(fs/2),120/(fs/2));
filtered_pulse = filter(b_peak, a_peak, filtered_pulse);

%% Plot
fig=figure(1);
clf;
plot(t, filtered_pulse,t,pulse);
xlabel('Time (s)'); ylabel('Amplitude'); 
legend('Filtered Pulse','Unfiltered Pulse'); title('Heartbeat Waveforms');
soundsc(filtered_pulse,fs);

%% Export

% Normalise
y = filtered_pulse./max(abs(filtered_pulse));
% Export
audiowrite('heartbeat.wav',y,fs);
