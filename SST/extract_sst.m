function sub_sst = extract_sst(sst,t1,t2,varargin)

%EXTRACT_SST: 
%
%USAGE: sub_sst = extract_sst(sst,t1,t2)
%       sub_sst = extract_sst(sst,t1,t2,method)
%
%INPUTS: sst --> Input Start/Stop Times Array
%        t1  --> lower time cut-off
%        t2  --> upper time cut-off
%        method --> 'split'(default),'full'
%
%OUTPUTS: sub_sst

[t1 t2] = chk_t('num',t1,t2);
method = 0; % default method: 'split'
if nargin < 3
   error('EXTRACT_SST: Too few input arguments')
elseif nargin > 4
   error('EXTRACT_SST: Too many input arguments')
elseif nargin == 4
   switch lower(varargin{1})
      case 'full'
         method = 1; % return only sst that are entirely between t1 and t2    
   end
end

%%
if is_sst(sst)
   if iscell(sst)
      for m = 1:numel(sst)
         sub_sst{m} = EXTRACT_SST(sst{m},t1,t2,method);
      end
   else
      sub_sst = EXTRACT_SST(sst,t1,t2,method);
   end
else
   error('EXTRACT_SST: Not a valid Start/Stop Time Argument')
end

%%   
function sub_sst = EXTRACT_SST(sst,t1,t2,method);  
   
sub_sst = [];
if isempty(sst) || t1 == t2
   return
end

if t2<t1
   temp = t1;
   t1 = t2;
   t2 = temp;
end

[N1 P1] = search_sst(t1,sst);
[N2 P2] = search_sst(t2,sst);

if P1 == 0
   sub_sst = sst(N1:N2-1,:);
else % P1 == 1
   sub_sst = sst(N1+1:N2-1,:);
end

if method == 0
   if (P1 == 0) && (P2 == 1)
      sub_sst = [sub_sst; sst(N2,1) t2];
   elseif (P1 == 1) && (P2 == 0)
      sub_sst = [t1 sst(N1,2); sub_sst];  
   elseif (P1 == 1) && (P2 == 1) && (N2-N1 == 0)
      sub_sst = [t1 t2];  
   elseif (P1 == 1) && (P2 == 1) && (N2-N1 > 0)
      sub_sst = [t1 sst(N1,2); sub_sst; sst(N2,1) t2];        
   end
end
