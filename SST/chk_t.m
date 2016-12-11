function varargout = chk_t(out,varargin)
%
%CHK_T: Check that all time inputs are valid, then output them in the 
%       format specified by 'out'
%
%USAGE: varargout = check_time(out,varargin) 
%                   (length of varargin equals length of varargout)
%             i.e.    
%                   [t1 t2 t3] = chk_t(out,t1,t2,t3)

if nargin-1~=nargout
   error('CHK_T: Number of time inputs must equal number of outputs')
end

for n=1:nargin-1
   t = varargin{n};
   if ischar(t)
      t = datenum(t);
   end
   if isnumeric(t) && size(t,1)==1 && size(t,2)==6
      t = datenum(t);
   elseif isnumeric(t) && size(t,1)==1 && size(t,2)==5
      t = [t 0];
      t = datenum(t);
   elseif isnumeric(t) && size(t,1)==1 && size(t,2)==4
      t = [t 0 0];
      t = datenum(t);
   elseif isnumeric(t) && size(t,1)==1 && size(t,2)==3
      t = [t 0 0 0];
      t = datenum(t);
   end
   if numel(t)==1 && isnumeric(t) && t>700000 && t<800000
      switch lower(out)
         case 'num'
            % good to go
         case 'str'
            t = datestr(t,0);
         case 'vec'
            t = datevec(t);
      end
   else
      disp(['Time Argument ',num2str(n),' is not valid'])
   end
   varargout(n) = {t};
end
      