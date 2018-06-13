![A model heart](/media/heart.jpg)

# heartbeat - A MATLAB script to synthesise a heartbeart

Create realistic sounding heartbeats suitable for use in action/thriller/horror films or simply your own amusement.

Image of a model heart is under public domain, CC0 license.

## Examples

[At Freesound.org](http://freesound.org/people/loudernoises/packs/18767/)

[Heartbeat at 60bpm](/media/heartbeat-60bpm.wav)

[Heartbeat at 140bpm](/media/heartbeat-60bpm.wav)

## Install

Download the repository and copy it to your MATLAB working directory. Voila!

## Usage

### Setting parameters, synthesising and exporting

There are two key parameters within the script which control the heartbeat:

- `numBeats`: The number of heartbeats synthesised.

- `tempoBpm`: The tempo of the heartbeat, i.e. the length between each beat.

These two parameters can be found in the first section *Simulation Settings*. The audio will save as `heartbeat.wav` in your present working directory. This string can be changed in the *Export* section.

## Advanced usage

### Plotting and auditioning within MATLAB

### Plot and Listen

There is a commented section, *Plot and Listen*, within the script. Uncommenting this will generate a time-domain waveform of the heartbeat being synthesised, and also allow for listening without opening the `.wav` externally. This allows for some intuitive analysis and quick design iterations.

![An example waveform](/media/heartbeat.png)

### Changing the filters

Examining the plot will show two waveforms: the first is the unprocessed heartbeat, the second the heartbeat with additional filtering. The additional filtering is added to recreate the sound of the chest cavity, to model a sound such as when a doctor is listening to your heart. The filters used are effectively two resonant filters, with their centre frequency adjusted relative to the tempo of the heartbeat.

    % Butterworth 3rd order bandpass
    [bBut, aBut] = butter(3,[20 140+tempo]/(0.5*fs),'bandpass');

    % Peaking filter
    [bPeak, aPeak] = iirpeak(110/(fs/2),120/(0.5*fs));

Changing the values in these lines will have the largest effect on the sound of the heartbeat.

### Changing the sections of the heartbeat

The unprocessed waveform is synthesised from multiple consecutive Hann windows (bell shaped lines). These are loosely based on an EKG, with sections: P, Q, R, etc. There are two parameters controlling each section, the length and the amplitude.

    % P
    pLength = floor((0.75 + rand()/2)*pulseNs/9);
    pAmp = (0.75 + rand()/2)*0.1;
    pVec = pAmp*hann(pLength).';

The lengths are given as a factor of the total length `pulseNs`. The amplitude is controlled with an offset, a random scaled number, and a scaling factor. The random number from `rand()` prevents the heartbeats sounding too similar, and will always fall between 0 and 1. By adding 0.75 to this, the section will never be silent. The scaling factor at the end of the expression is the value that will give the best results when changed.

## License

MIT © Ben Holmes
