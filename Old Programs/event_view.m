function event_view(event,frame)
%
%EVENT_VIEW: Plot event wf in red against longer continuous wf in black
%
%USAGE: event_view(event,frame)
%
%INPUTS: event - event (waveform object)    
%        frame - event frame (1x2 double) (unit: event lengths)
%              i.e. frame=[1 1] will plot an event of length L in red with
%              data of length L before and after the event (3L total).
% 
%OUTPUTS: none, generates a plot

l_v = get(event,'data_length'); % Data Length (event)
Fs  = get(event,'freq') ;   
dt = 1/Fs;

front = frame(1)*l_v;           % Data before event
rear = frame(2)*l_v;            % Data after event

w2 = expand(event,front,rear,'dp');
xT = dt:dt:dt*get(w2,'data_length');

ev_nan = event_wfa2nan(w2, event);

figure
g(1) = subplot(2,1,1);
plot(w2,'xunit','seconds')
xlim([min(xT) max(xT)])
hold on
plot(ev_nan,'color',[1 0 0])

%%%%% Make Spectrogram %%%%

nf_rng = [0 .5];
F_range = nf_rng*Fs;
v = get(w2,'data');
w = Fs;                         % 1 second bins(time axis)
n_bins = floor(length(v)/w);    % Number of bins in spectrogram matrix
fft_array = zeros(w/2, n_bins); % Spectrogram matrix
for n = 1:floor(length(v)/w)    % Assemble FFT columns into spectrogram 
    temp = v(n*w-(w-1):n*w);
    temp = temp - sum(temp)/w;
    fft_temp = fftshift(abs(fft(temp)));
    fft_temp = fft_temp(w/2+1:w);
    fft_array(:,n)= fft_temp;
end
warning off
fft_array = fft_array(1:w/2*nf_rng(2),:); % Remove freqs above max(F_range)
warning on
%%%%% Plot Spectrogram %%%%

g(2) = subplot(2,1,2);
imagesc(xT,F_range,fft_array);
ylabel('Frequency (Hz)')
set(gca,'YDir','normal') 
xlim([min(xT) max(xT)])
linkaxes(g,'x')
