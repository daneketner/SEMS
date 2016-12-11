function sst = delete_sst(sst,t1,t2,varargin)

%DELETE_SST: 
%
%USAGE: sst = delete_sst(sst,t1,t2)
%       sst = delete_sst(sst,t1,t2,method)
%
%INPUTS: sst -->
%        t1  -->
%        t2  -->
%        method -->
%
%OUTPUTS: sst

method = 0; % default method: 'split'
if nargin < 3
   error('DELETE_SST: Too few input arguments')
elseif nargin > 4
   error('DELETE_SST: Too many input arguments')
elseif nargin == 4
   switch lower(varargin{1})
      case 'full'
         method = 1; % merge new sst
      case 'part'
         method = 2; % merge new sst
   end
end

%% EVERYTHING BELOW THIS LINE BELONGS TO EXTRACT_SST AND HAS NOT YET BEEN
%% MODIFIED FOR DELETE_SST

[N1 P1] = search_sst(t1,sst);
[N2 P2] = search_sst(t2,sst);

if P1 == 1 
   if method == 0
      first = [t1 sst(N1,2)];
   elseif method == 1
      first = [];
   end    
elseif P1 == 0
   first = sst(N1,:);
end

if P2 == 1 
   if method == 0
      last = [sst(N2,1) t2];
   elseif method == 1
      last = [];
   end    
elseif P2 == 0
   last = sst(N2-1,:);
   N2 = N2-1;
end

sub_sst = [first; sst(N1+1:N2-1,:); last];