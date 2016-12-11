function [Inst_Freq_Hz Inst_Amplitude imf] = hht(wave)
%
%HHT: Hilbert-Huang transform
%
%INPUTS: wave - waveform object    
%
%OUTPUTS: Inst_Freq_Hz
%         Inst_Amplitude

v = get(wave,'data');
Fs = get(wave,'freq');       % Sampling Rate
imf = eemd(v,0,1);           % Empirical Mode Decomposition
imf = imf(:,2:end);          % non-IMF is ommited (original signal)
H = hilbert(imf);            % Hilbert transform
omega = unwrap(angle(H));
dwdt = (diff(omega));        %Radians/sec  
dwdt(length(v),:) = dwdt(length(v)-1,:);
Inst_Freq_Hz = abs(dwdt/(2*pi)*Fs);
Inst_Amplitude = abs(H);
