function [Skp_times] = dc_tel_noise(wave,sen)
%
%TEL_NOISE: Locates DC telemetry noise in signal.
%
%[Skp_times] = dc_tel_noise(wave,sen)
%
%INPUTS: wave - a waveform object containing telemetry noise (maybe)
%        sen - sensitivity value for telemetry noise detection (try 100)
%
%OUTPUTS: Skp_times - 2xn array of noise start/stop times (matlab format)
%
%                   /\  /\  /\  /\     <-- Telemetry 'jumps'
%                  |  \/  \/  \/  |
%                  |              |
%  /\  /\  /\  /\  |              |  /\  /\  /\
%    \/  \/  \/  \/                \/  \/  \/  \/
%
%          |_______|_______| --> sliding window -->
%              w1      w2
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

v = get(wave,'data');          % Waveform Data
Fs = get(wave,'freq');         % Sampling Rate
l_v = length(v);               % Data Length
t_v = get(wave, 'timevector'); % Data Time Vector

J = zeros(1,l_v);   % Jump value (Large around a DC step)
S = zeros(1,l_v);   % Swell value (Large around energetic swell like a VT)
Skp = zeros(1,l_v); % Skip value (1 if telemetry jump, 0 otherwise)
Skp_NaN = Skp*NaN;  % Like Skp w/ NaN instead of 0, used for plotting 
Skp_times = [];     % 2xn array of Skip on/off times

l_w = 2*Fs;         % Size of telemetry noise checking window
inc = Fs/20;        % Sliding window increment value
w1 = [1 l_w];       % Window 1 (left)
w2 = [l_w+1 2*l_w]; % Window 2 (right)
k = w2(2);          % Start reference at far right of window
while k <= l_v-inc
   v1 = v(w1(1):w1(2));  v2 = v(w2(1):w2(2)); % Current window data
   m1 = mean(v1);        m2 = mean(v2);       % Current window mean
   J(k:k+inc-1) = abs(m1-m2);                              % J Value
   S(k:k+inc-1) = abs(mean(abs(v1-m1))-mean(abs(v2-m2)));  % S Value
   if (J(k)>sen)&&(S(k)<J(k))              % DC noise detection criteria
      Skp(k-l_w-Fs:k+inc-l_w+Fs) = 1;      % Noise is padded either side
      Skp_NaN(k-l_w-Fs:k+inc-l_w+Fs) = 1;
   end
   k=k+inc; w1=w1+inc; w2=w2+inc;  % Increment window --> |__|__| -->
end
for n = 2:length(Skp) % Loop builds 'Skp_times'
   if (Skp(n)==1)&&(Skp(n-1)==0)
      Skp_start = t_v(n);
   elseif (Skp(n)==0)&&(Skp(n-1)==1)
      Skp_end = t_v(n-1);
      Skp_times = [Skp_times; Skp_start Skp_end];
   end
end
%%%% Uncomment lines below to plot DC telemetry noise over signal
%
skp_wave = Skp_NaN.*wave;
figure
plot(wave),hold on, plot(skp_wave,'color',[1 0 0])
