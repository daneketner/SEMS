clear all; clc

%host='avovalve01.wr.usgs.gov';  
host='pubavo1.wr.usgs.gov';
port=16022;
ds = datasource('winston',host,port);

station='AUW';             % Station
channel='EHZ';             % Channel
network='AV';              % Network    

t_start=[2010 08 12 07 34 10]; % Start time (YYYY MM DD HH MM SS)
t_end=  [2010 08 12 07 34 11]; % End time   (YYYY MM DD HH MM SS)

% t_start=[2010 08 12 23 39 02]; % Start time (YYYY MM DD HH MM SS)
% t_end=  [2010 08 12 23 39 03]; % End time   (YYYY MM DD HH MM SS)

scnl = scnlobject(station,channel,network);
w = waveform(ds,scnl,datestr(t_start,0),datestr(t_end,0));
v = get(w,'data');
Fs = get(w,'freq');                % Sampling Frequency (Hz)
dt = 1/Fs;                         % Sample Time
T = get(w,'timevector');           % Vector of Time Instances (Matlab Format)
xT = dt:dt:length(T)*dt;           % Vector of Time Instances (Seconds from t_start)

tone_freq = 21.25;

L = Fs;
x = 1:L;

f_arr = tone_freq*[1/9 1/6 1/3 1];
Lf = length(f_arr);
power = zeros(Lf,1);
for n = 1:Lf

freq = f_arr(n)/Fs;
coeff = 2*cos(2*pi*freq);

s_prev = 0;
s_prev2 = 0;

for m=1:L
  s = v(m) + coeff*s_prev - s_prev2;
  s_prev2 = s_prev;
  s_prev = s;
end
power(n,1) = s_prev2*s_prev2 + s_prev*s_prev - coeff*s_prev2*s_prev;
end

power(4,1)/sum(power(1:3,1))

figure
subplot(3,1,1)
plot(v)
xlim([1 length(v)])
subplot(3,1,2)
plot(f_arr,power)
subplot(3,1,3)
fft_v = fftshift(abs(fft(v)));
plot(fft_v(round(length(fft_v)/2):length(fft_v)))


