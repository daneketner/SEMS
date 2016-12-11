function wspectrogram(w,freq_max)

% Waveform object overload of spectrogram function

x = get(w,'data');
Fs = get(w,'freq');
tv = get(w,'timevector');
S = abs(spectrogram(x,Fs,Fs*.8,128,Fs));
M=max(max(S));
warning off
S = 10*log10(S/M);
warning on
inf = -20;
figure
imagesc(tv,[0 Fs/2],S,[inf,0]);
dynamicDateTicks
%colormap(bone)
ylabel('Frequency (Hz)')
xlabel('Time (UTC)')
set(gca,'YDir','normal') 
xlim([tv(1) tv(end)])
ylim([0 freq_max])