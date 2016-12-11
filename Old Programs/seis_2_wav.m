SeisData_split = zeros(6,10000);
fft_split = zeros(6,10000);

Fs = 50;                    % (Hz)Sampling frequency
T = 1/Fs;                   % Sample time
L = 60000;                     % Length of signal
t = (0:L-1)*T;                % Time vector


for n = 1:6

SeisData_split(n,:) = SeisData((n-1)*10000+1:n*10000);

fft_split(n,:) = abs(fftshift(fft(SeisData_split(n,:))));

end



for n = 1:6

figure(1)
subplot(6,1,n)
plot(t((n-1)*10000+1:n*10000),(SeisData_split(n,:)))

figure(2)
subplot(6,1,n)
plot(fft_split(n,:))

end

figure(3)
subplot(2,1,1)
plot(SeisData)
subplot(2,1,2)
plot(abs(fftshift(fft(SeisData))));

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% figure(1)
% plot(SeisData)
% 
% SeisData_split = zeros(60,1000);
% fft_split = zeros(60,1000);
% 
% for n = 1:60
% 
% SeisData_split(n,:) = SeisData((n-1)*1000+1:n*1000);
% 
% fft_split(n,:) = abs(fftshift(fft(SeisData_split(n,:))));
% 
% figure(2)
% plot(fft_split(n,:))
% 
% M(n) = getframe;
% 
% end
% 
% movie(M,1)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% SeisData_split = SeisData(1:1000);
% 
% fft_split = abs(fftshift(fft(SeisData_split)));
% plot(fft_split)










