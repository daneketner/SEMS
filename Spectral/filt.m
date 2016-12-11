function wave = filt(wave,f_type,f_rng)

%FILT: Quick function for filtering waveforms and avoiding the hassle of
%      generating a filterobject
%
%USAGE: wave = filt(wave,f_type,f_rng)
%
%INPUTS:  wave - input waveform
%         f_type - 'lp', 'hp', 'bp' (all 2 pole filters)
%OUTPUT: wave - filtered waveform

wave = fillgaps(wave,0);
if strcmpi(f_type,'bp')
   wave = filtfilt(filterobject('B',f_rng,2),wave);
elseif strcmpi(f_type,'hp')
   wave = filtfilt(filterobject('H',f_rng,2),wave);
elseif strcmpi(f_type,'lp')
   wave = filtfilt(filterobject('L',f_rng,2),wave);
elseif strcmpi(f_type,'med')   
   d = get(wave,'data');
   d = medfilt1(d,f_rng);
   wave = set(wave,'data',d); 
end
