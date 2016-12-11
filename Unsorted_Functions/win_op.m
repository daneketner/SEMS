function w_o = win_op(w,l,op,pos)
%
%WIN_OP: Perform time-averaged operation over a sliding window of waveform
%        values. Mean(), Mean(Abs()), Median(), Median(Abs()),Max(),
%        Max(Abs()), & Min() can all be performed over a sliding window
%        of values from w. Window length and position of windowed values
%        is user-defined
%
%USAGE: w_o = win_op(w_i,l,op,pos)
%
%DIAGRAM:
% w:      
%            /\      /\/\        /\              /\      /\/\        /\    
%\  /\  /\/\/  \/\  /    \/\    /  \/\  /\  /\/\/  \/\  /    \/\    /  \/\ 
% \/  \/          \/        \/\/      \/  \/          \/        \/\/      \                   
%                                           
%         --> |--sub_w--| -->  op = 'meanabs', pos = 'right'
% w_o:                 __                                 _         _         
%          __/\_   ___/  \__    __/\__    __    __/\_  __/ \_/\   _/ \__  
%_________/     \_/         \__/      \__/  \__/     \/        \_/      \_/
%
%INPUTS: w   - input waveform object
%        l   - length of window over which to perform op (datapoints)
%        op  - operation: 'mean', 'meanabs', 'median', 'medianabs'
%                         'max', 'maxabs', 'min'
%        pos - defines where windowed values are stored in w_o:
%                'right': w_o is zero padded on left end
%                'left' : w_o is zero padded on right end
%                'mid'  : w_o is zero padded equally on both sides
%   
%OUTPUTS: w_o - waveform object containing window-operated values from w
%
%EXAMPLES: (STA/LTA) Calculate short-term average, long-term average ratio
%           sta = win_op(w,1,'meanabs','right');
%           lta = win_op(w,8,'meanabs','right'); 
%           sta_lta_ratio = sta./lta; 

v_i = get(w,'data');       % input data
lv = get(w,'data_length'); % length of v_i
v_o = zeros(lv,1);         % output data (initialized to 0)
  
k = 1;    % reference to first point in window
kk = l;   % reference to last point in window

switch lower(pos) 
   case {'left'}
      p = k;
   case 'right'
      p = kk;
   case 'mid'
      p = round((kk-k)/2);
   otherwise
end

switch lower(op)
   case {'meanabs','medianabs','maxabs'}
      v_i = abs(v_i);
   otherwise
end

switch lower(op) % initialize
      case {'mean','meanabs'}
         sub_v_sum = sum(v_i(k:kk));
         v_o(p) = sub_v_sum/l;
      case {'median','medianabs'}
         % Not currently implemented
      case {'max','maxabs'}
         % Not currently implemented
      case 'min'
         % Not currently implemented
end

for k = 2:lv-l
   p = p+1;
   kk = kk+1;
   switch lower(op)
      case {'mean','meanabs'}
         sub_v_sum = sub_v_sum - v_i(k-1) + v_i(kk);
         v_o(p) = sub_v_sum/l;
      case {'median','medianabs'}
         % Not currently implemented
      case {'max','maxabs'}
         % Not currently implemented
      case 'min'
         % Not currently implemented
   end
end

w_o = set(w,'data',v_o);
