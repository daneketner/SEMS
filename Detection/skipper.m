function [skp] = skipper(wave,varargin)
%
%SKIPPER: Returns list of start/stop times to skip over during event 
%         detection, this includes (1) data gaps (2) telemetry noise 
%         (3) cal pulses
%
%USAGE: [skp] = skipper(wave,varargin) 
%
%INPUTS: wave - a waveform object
%        varargin - 'gap' - find data gap regions
%                 - 'tel' - find DC telemetry noise regions
%                 - 'cal' - find calibration pulses
%                 - 'ssd' - return skp as start/stop data points nx2
%                 - 'wfa' - return skp as a waveform array 1xn
%                 - 'sst' - return skp as start/stop times (default) nx2
%
%OUTPUTS: skp - Regions of data to skip during automated event detection            
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

tel_sst = [];
gap_sst = [];
cal_sst = [];
type = 'sst';

for n = 1:length(varargin)
   switch lower(varargin{n})
      case 'tel'
         tel_sst = dc_tel_noise(wave,90);
      case 'gap'
         gap_sst = get_gaps(wave);
      case 'cal'
         cal_sst = cal_pulse(wave,'sst');
      case 'ssd'
         type = 'ssd';
      case 'wfa'
         type = 'wfa';
   end
end

r = sort([tel_sst; gap_sst; cal_sst]);
n = 1;
flag = 0;
while n<length(r)  % If any overlap, merge them
   if (r(n,2) >= r(n+1,1)) && (r(n+1,2) >= r(n,2)) % Partial Overlap
      r(n,:) = [r(n,1) r(n+1,2)];
      r(n+1,:) = [];
      flag = 1;
   elseif (r(n,2) >= r(n+1,1)) && (r(n,2) >= r(n+1,2)) % Full Overlap
      r(n+1,:) = [];  
      flag = 1;
   end
   if flag == 0
   n=n+1;
   end
end

switch type
   case 'sst'
      skp = r;
   case 'ssd'
      tv = get(wave,'timevector');
      for n = 1:numel(r)           % Loop converts start/stop times
         skp(n) = find(r == tv);   % to start/stop data points
      end                          % sst --> ssd 
   case 'wfa'
      skp = sst2wfa(r,wave);
end


