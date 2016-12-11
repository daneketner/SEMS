function w = set2val(w,sst,val)

%SET2VAL: Set sections of waveform w (specified by time sst) to a single 
%   value. This function can be used to zero-out, or NaN-out unwanted
%   periods of a waveform such as calibration pulses, or telemetry noise.
%
%USAGE: w = set2val(w,sst,val)
%
%INPUTS: 
%        w   - Waveform object that contains sections to delete
%        sst - Start/Stop Times (nx2 array of matlab times)
%        val - Numeric value used to replace waveform data in sst
%
%OUTPUTS: w - Original waveform with sst set to val

%%
if isempty(sst)|| iscell(sst) && isempty(sst{:})
   return
end
if iscell(sst)
   if numel(sst) == numel(w)
      for l = 1:numel(sst)
         w(l) = SET2VAL(w(l),sst{l},val);
      end
   else
      error(['SET2VAL:ArgumentDimensions - Number of elements in',...
             ' waveform input ''w'' and cell input ''sst'' must match']);
   end
else
   w = SET2VAL(w,sst,val);
end

%%
function w = SET2VAL(w,sst,val)
nn = size(sst,1);

for n=1:nn
   if n == 1
      wfa(n) = extract(w,'time',get(w,'start'),sst(n,1));
      r_wfa(n) = extract(w,'time',sst(n,1),sst(n,2));
      r_wfa(n) = (r_wfa*0+1)*val;
      wfa(n) = combine([wfa(n) r_wfa(n)]);
   else
      wfa(n) = extract(w,'time',sst(n-1,2),sst(n,1));
      r_wfa(n) = extract(w,'time',sst(n,1),sst(n,2));
      r_wfa(n) = (r_wfa(n)*0+1)*val;
      wfa(n) = combine([wfa(n) r_wfa(n)]);
   end
end
wfa(nn+1) = extract(w,'time',sst(nn,2),get(w,'end'));
w = combine(wfa(:));
