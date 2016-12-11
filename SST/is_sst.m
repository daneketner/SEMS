function bool = is_sst(sst)
%
%IS_SST 

bool = 1;
if iscell(sst)
   for m = 1:numel(sst)
      if ~isnumeric(sst{m})||size(sst{m},2)~=2;
         bool =  0; 
      end
   end
elseif ~isnumeric(sst)||size(sst,2)~=2;
   bool =  0; 
end
