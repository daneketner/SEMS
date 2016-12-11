function fwave = bp_filt(wave,varargin)
%
%BP_FILT: Band Pass Filter all waveform objects: default = [1Hz to 15Hz]
%
%USAGE: fwave = bp_filt(wave)          --> [1 15] default filter cutoffs
%       fwave = bp_filt(wave,[f1 f2])  --> [f1 f2] user-defined (Hz)        
%
%INPUTS: wave - input waveform object(s)   
%        
%OUTPUTS: fwave - output waveform object(s) (filtered)

if nargin > 1
   range = varargin{1};
else
   range = [1 15];
end 

f_bp = filterobject('B',range,2);      % 2 pole band-pass butterworth
for n = 1:numel(wave)
   fwave(n) = filtfilt(f_bp,wave(n));        
end