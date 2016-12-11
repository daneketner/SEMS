%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
%   Analysis of Lowpass filtering on HHT spectrum
%   Rolan Baguyos, Dane Ketner, Sunil Panthi
%   Last modified March 22, 2010
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear,clc

load RDN_EHZ_R.mat

Fs = 50;                               % Sampling frequency (Hz)
dt = 1/Fs;                             % Sample time

startData = 47500;        % Defines start and end of 'partial'
endData = 50000;

partial = SeisData(startData : endData);        % partial data set

L_total = length(SeisData);           % Length of total signal
L_part = length(partial);             % Length of partial signal

t_total = (1:L_total)*dt;             % Time vector of total
t_part = (startData:endData)*dt;      % Time vector of partial

lp_signals(:,1) = partial;

lp_1 = fir1(3,.5);
lp_signal_1 = conv(lp_1,partial);
lp_signal_1 = lp_signal_1(1:L_part);

lp_2 = fir1(7,.5);
lp_signal_2 = conv(lp_2,partial);
lp_signal_2 = lp_signal_2(1:L_part);

lp_3 = fir1(15,.5);
lp_signal_3 = conv(lp_2,partial);
lp_signal_3 = lp_signal_3(1:L_part);

lp_signals(:,2) = lp_signal_1;
lp_signals(:,3) = lp_signal_2;
lp_signals(:,4) = lp_signal_3;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
%  Plot Filtered Signals
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

figure

for n = 1:4
    
subplot(4,1,n)
plot(t_part,lp_signals(:,n));
xlabel('Time[s]')

end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%  Plot combined IMFs and their HHT specrum
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

figure

for n = 1:4
    
super(1:L_part,1) = 0;

emd = eemd(lp_signals(:,n),0,1);
imf_set = [4 5 6 7 8 9 10 11];
emd_sub = emd(:,imf_set);                    % select IMF to plot

s = size(emd_sub);
for i = 1 : s(2)
super = super + emd_sub(:,i);
end

H = hilbert(emd_sub);

omega = unwrap(angle(H));
dwdt = (diff(omega));

dwdt(L_part,:) = dwdt(L_part-1,:);

Inst_Amplitude = abs(H);

[im,tt] = toimage(Inst_Amplitude',5*dwdt',t_part);

Smooth_g = gausswin(30);
im = conv2(im, Smooth_g);
im = im';
im = conv2(im, Smooth_g);
im = im';

M=max(max(im));
warning off
im = 10*log10(im/M);
warning on
inf = -20;
subplot(4,1,n)
imagesc(t_part,[0,0.2*Fs],im,[inf,0]);
ylabel('Frequency (Hz)')
set(gca,'YDir','normal') 
xlabel('Time (s)')

end


