function varargout = findlocval(w,t,varargin)

%FINDLOCVAL: Find Local Values, Search for values in w that are local to 
%            reference times in t.
%
%USAGE: varargout = findlocval(w,t,varargin)
%
%INPUTS: w - a waveform object
%        t - array of time reference points from w
%        varargin - (length is multiple of 3) containing:
%                 (1) direction: 'left', 'right'
%                 (2) comparison: '<', '>'
%                 (3) value: a number value
%
%EXAMPLE: t contains a list of peak values and we want to know when the
%         signal drops below the value 100 to the left of the peaks:
%
%         a = findlocval(w,t,'left','<',100);
%
%       Suppose we want to also know where the signal drops below 150
%       to the right of the peak times:
%
%         b = findlocval(w,t,'right','<',150);
%
%       We accomplish both by combining the command:
%
%         [a,b] = findlocval(w,t,'left','<',100,'right','<','150');
%
%OUTPUTS: events - waveform object array of detected events

dat = get(w,'data');
tv = get(w,'timevector');
dl = get(w,'data_length');
v = varargin;
nv = numel(v);
if ~rem(nv,3) == 0
   error(['findlocalval:ArgumentFormat - '...
          'Arguments after t must appear in sets of 3'])
end

for n = 1:nv/3
   tt = t*0;
   dir = v{(n-1)*3+1};   % Current direction
   if strcmpi(dir,'left')
      dir = -1;
   elseif strcmpi(dir,'right')
      dir = 1;
   else
      error(['findlocalval:BadArgumentType - '...
          'direction must be: ''left'', ''right''.'])
   end
   
   comp = v{(n-1)*3+2};  % Current comparison
   if strcmp(comp,'<')
      comp = -1;
   elseif strcmp(comp,'>')
      comp = 1;
   else
      error(['findlocalval:BadArgumentType - '...
          'comparison must be: ''<'', ''>''.'])
   end
   
   val = v{(n-1)*3+3};   % Current value
   if ~isnumeric(val)
      error(['findlocalval:BadArgumentType - '...
          'value must be numeric.'])
   end
   
   for m = 1:numel(t)
      [zz,jj] = min(abs(tv-t(m)));
      found = 0;
      while found == 0
         if jj>1 && dir==-1
            jj=jj-1;
         elseif jj<dl && dir==1
            jj=jj+1;
         end
         if ((comp == 1)&&(dat(jj)>val))||((comp == -1)&&(dat(jj)<val))
               tt(m) = tv(jj);
               found = 1;
         end
      end
   end
   varargout(n)={tt};
end