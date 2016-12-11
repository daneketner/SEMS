function gap_sst = get_gaps(w)
%
%GET_GAPS: Make gaps NaN & returns array of gap start/stop times
%
%USAGE: gap_sst = get_gaps(w)
%
%INPUTS: w - a waveform object containing gaps noise (maybe)
%
%OUTPUTS: w - waveform object w/ gaps zeroed out
%         gap_sst - array of gap start/stop times (nx2)
%
%  /\  /\  /\  /\  ________________  /\  /\  /\  ...
%    \/  \/  \/  \/                \/  \/  \/  \/
%                 t1              t2              gap_sst = [t1 t2; ...]
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

wave = zero2nan(w,10);    % Gaps longer than 10 samples are NaNed
v = get(wave,'data');        % Waveform Data
tv = get(wave,'timevector'); % Events time array
l_v = length(v);             % Data Length

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% get gap times %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

k = 1;           % start at first sample in data set
gap_sst = [];    % nx2 matrix of start/stop times
gap_cnt = 0;     % Number of gaps found
gap_flag = 0;    % In a gap currently?

while k < l_v
   if isnan(v(k)) 
      if gap_flag == 0 % Found the beginning of a NaN gap
         gap_flag = 1;
         gap_cnt = gap_cnt + 1;
         gap_sst(gap_cnt,1) = tv(k);
      end
   elseif isnumeric(v(k))
      if gap_flag == 1 % Found the end of a NaN gap
         gap_flag = 0;
         gap_sst(gap_cnt,2) = tv(k-1); 
      end
   end
   k = k+1;
end
         