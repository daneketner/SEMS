function [g f]=goertzelsft(wave)
%
%GOERTZELSFT: Goertzel's Sliding Algorithm (Slow Fourier Transform)
%             Smoothed FFT, similar to zero padding data before FFT
%             Wikipedia 'Goertzel's Algorithm' for info
%
%INPUTS: wave - waveform object    
%        norm_freq_range - 1x2 array containing normalized frequency range
%        (i.e. [0 .5])
%
%OUTPUTS: g - GSA (similar output to FFT with improved resolution 
%             over shorter windows)
%         f - frequencies of GSA in Hz (length(g)=length(f))

v = get(wave,'data');
Fs = get(wave,'freq');
Ny_Fs = Fs/2;
v_l = get(wave,'data_length');
f = 0:.01:Ny_Fs;
f_l = length(f);
power = zeros(f_l,1);
for n = 1:f_l

freq = f(n)/Fs;
coeff = 2*cos(2*pi*freq);

s_prev = 0;
s_prev2 = 0;

for m=1:v_l
  s = v(m) + coeff*s_prev - s_prev2;
  s_prev2 = s_prev;
  s_prev = s;
end
power(n,1) = s_prev2*s_prev2 + s_prev*s_prev - coeff*s_prev2*s_prev;
end

g = power;






