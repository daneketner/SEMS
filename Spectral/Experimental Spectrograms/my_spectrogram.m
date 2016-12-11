
figure

w = 50;  % Spectrogram window size
ov = 45; % Spectrogram overlap size

partial = partial - sum(partial)/length(partial);

[SS,FF,TT]=spectrogram(partial,w,0,0:.1:F_range(2),Fs);
SS = abs(SS);
subplot(2,2,1)
imagesc(t_part,F_range,SS);
ylabel('Frequency (Hz)')
set(gca,'YDir','normal') 
title('Matlab Spectrogram')



for n = 1:floor(length(partial)/w) 
    
    temp = partial(n*w-(w-1):n*w);
    temp = temp - sum(temp)/w;
    
    fft_temp = fftshift(abs(fft(temp)));
    fft_temp = fft_temp(w/2+1:w);
    
    fft_array(:,n)= fft_temp;
    
end

subplot(2,2,2)
imagesc(t_part,F_range,fft_array);
ylabel('Frequency (Hz)')
set(gca,'YDir','normal') 
title('Improved Spectrogram')
xlim([startData/Fs endData/Fs])

subplot(2,2,3)
contour(SS)
ylabel('Frequency (Hz)')

subplot(2,2,4)
contour(fft_array)
