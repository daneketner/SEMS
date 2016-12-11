% Map multiple spectrograms into additive matrix

F_s = 50; % Sampling rate
res = 5;  % window resolution
x_big = length(partial)/res;
y_big = 2*F_s;
wft_big = zeros(x_big, y_big);

for w = [F_s F_s*2 F_s*4]

x_temp = floor(length(partial)/w);
y_temp = w/2;
wft_temp = zeros(x_temp, y_temp);

    for n = 1:x_temp
    
    temp = partial(n*w-(w-1):n*w);
    temp = temp - sum(temp)/w;
    fft_temp = fftshift(abs(fft(temp)));
    fft_temp = fft_temp(w/2+1:w);
    wft_temp(n,:)= fft_temp;   
    
    end   
    
    % map into full matrix 
    
    xd = x_big/x_temp;
    yd = y_big/y_temp;
    wft_big_dum = wft_big;

    for p = 1:x_temp
        for q = 1:y_temp
           for rx = 1:xd
               for ry = 1:yd
            
                wft_big_dum((p-1)*xd+rx, (q-1)*yd+ry) = wft_temp(p, q);
                wft_big = wft_big + wft_big_dum/w;
            
               end            
           end
        end
    end
            
        

end
figure
subplot(2,1,1)
imagesc(t_part,F_range,wft_big);
ylabel('Frequency (Hz)')
set(gca,'YDir','normal') 
title('Windowed Fourier Spectrum')
xlim([startData/Fs endData/Fs])
