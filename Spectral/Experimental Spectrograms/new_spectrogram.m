function new_spectrogram(wave,nf_rng)
%
%NEW_SPECTROGRAM: Sliding hanning windowed fft
%
%INPUTS: wave - waveform object    
%        nf_rng - 1x2 array containing normalized frequency range
%           (i.e. [0 .5])
%
%OUTPUTS: none, generates a plot

host = 'avovalve01.wr.usgs.gov';
port = 16022;
ds = datasource('winston',host,port);

station=get(wave,'station');          % Station
channel=get(wave,'channel');          % Channel
network=get(wave,'network');          % Network 
scnl = get(wave,'scnlobject');
Fs = get(wave,'freq');
dt = 1/Fs;
Ny_Fs = Fs/2;
F_range = nf_rng*Ny_Fs;      % Frequency range to plot

v_a = get(wave, 'data');
L_a = length(v_a);
xt = dt:dt:dt*L_a;           % Vector of Time Instances (Seconds from t1_a)

t1_a = get(wave, 'start');
t2_a = get(wave, 'end');
dur = t2_a-t1_a;
t1_b = t1_a-dur/2;
t2_b = t2_a+dur/2;
t1_b_str = datestr(t1_b,0);
t2_b_str = datestr(t2_b,0);

wave_b = waveform(ds,scnl,t1_b_str,t2_b_str); 
v_b = get(wave_b, 'data');
L_b = length(v_b);
off = (L_b-L_a)/2;        % v_a(n) = v_b(n+off)   'offset'

bin_h = .05;              % height of bin (Hz)
f = bin_h:bin_h:Ny_Fs;    % array of freqs (Hz)
spg_h = length(f);        % spectrogram height (bins)
win_w = round(4*Fs./f);   % window width @ each f (data points)
for n = 1:spg_h
    if win_w(n)>L_a
        win_w(n)=L_a;
    end
end
bin_w = 5;                % width of bin (data points) (odd number)
mid = ceil(bin_w/2);      %
k = off+mid;               
d = (k:bin_w:L_a+k);      % array of bin mid points (data points from v_b(1))
spg_w = floor(L_a/bin_w); % spectrogram width (bins)

warning off
for n = 1:spg_w
   for m = 1:spg_h
      
      j = floor(win_w(m)/2); 
      win_v = v_b(d(n)-j:d(n)+j);
      f_rad = f(n)/Fs*2*pi;
      coeff = 2*cos(f_rad);

      s_prev = 0;
      s_prev2 = 0;

      for r=1:length(win_v)
         s = win_v(r) + coeff*s_prev - s_prev2;
         s_prev2 = s_prev;
         s_prev = s;
      end
   fft_array(n,m) = sqrt((s_prev2*s_prev2 + s_prev*s_prev - coeff*s_prev2*s_prev)/length(win_v));
   end
end
warning on
figure
imagesc(xt,F_range,fft_array');
ylabel('Frequency (Hz)')
xlabel(['Time (seconds), start ',get(wave,'start_str'),' (UTC)'])
set(gca,'YDir','normal') 
title(['Improved FFT [',station,' ',channel,' ',network,'] '])
xlim([min(xt) max(xt)])

