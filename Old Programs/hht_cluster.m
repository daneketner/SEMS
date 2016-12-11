
Fs = get(w2(1),'freq');               % Sampling Rate
dt = 1/Fs;                            % Sampling Period
l_v = get(w2(1),'data_length');       % Data Length
xT = dt:dt:dt*l_v;                    % Vector of Time Instances (Seconds from t_start)
Ny_Fs = Fs/2;                         % Nyquist Frequency
nfr = [0 .1*1.5/5];
imf_rng = [5 5];
F_range = nfr*Ny_Fs;       % Freq range to plot (0 to Ny_Fs)
IM = zeros(400,1001);
for n = 1:15
   [im] = plot_hht(w2(n),nfr,imf_rng);
   IM = IM + im;
end
figure
M=max(max(IM));
warning off
IM = 10*log10(IM/M)*.8;
warning on
inf = -20;

imagesc(xT,F_range,IM,[inf,0]);
ylabel('Frequency (Hz)')
xlabel('Time (seconds)')
title('Cluster 2 (15 events)')
set(gca,'YDir','normal') 
    