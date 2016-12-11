function [tt cc] = evoCorDet(erw,ds,varargin)

%EVOCORDET: Evolving Correlation Detector - Detects repeating waveforms by 
%   cross correlating continuous seismic data with a temporally-evolving 
%   reference waveform (ERW). This technique has been used to identify 
%   thousands of repeating seismic events during volcanic eruptions, even 
%   when SNR and event spacing become small and traditional STA/LTA 
%   detection becomes untenable. As new events are detected, they are 
%   stacked with current reference waveform. Rate of Replacement (ROR) is 
%   a scaling factor between 0 and 1 (default is .05) that determines how 
%   rapidly ERW adapts according to the schema: ERW = ERW(1-ROR)+w(ROR) 
%   where 'w' is the newly detected waveform event. A higher ROR will be
%   more adaptable, and a lower ROR will be more stable. evoCorDet will
%   move forward through
%
%USAGE: [t cc] = evoCorDet(erw,ds,scnl)
%       [t cc] = evoCorDet(erw,ds,scnl,prop_1,val_1,...)
%
%REQUIRED INPUTS: 
%   erw - a waveform object used as the initial reference waveform for 
%          detection via correlation. The length of erw will determine the 
%          length of the window being correlated.
%   ds - datasource object from which to fetch waveforms
%   scnl - SCNL object
%   
%VALID PROP/VAL:
%   start - where in time to begin detections within continuous data
%           DEFAULT = start time of initial ERW waveform
%   evo_ct - Evolve Correlation Threshold, newly detected waveforms 
%            correlating above this threshold will be used to modify ERW.
%            RANGE: [0-1], DEFAULT: .75
%   sav_ct - Save Correlation Threshold, waveforms correlating above this 
%            threshold will be recorded but not used to modify ERW.
%            RANGE: [0-1], DEFAULT: .6
%   dist - Quit searching for events after they are seperated by this 
%          distance (in days) *default = .5
%   block - size of incremental waveform blocks (in days) over which to 
%           search for events *default = .25, or 6 hours
%   ror - erw rate of replacement (0-1) *default = .05        
%   bpf - bandpass filter limits for incoming waveform blocks
%         *default = [1 15] --> Note: no filtering of original erw    
%   plot - plot evolution of erw every time erw is updated (1 or 0)
%          DEFAULT: 1 (Plot on, this is fun to watch)
%   scnl - SCNL obect of waveform blocks
%         DEFAULT: SCNL object extracted from ERW input
%OUTPUTS: tt - time values of detections (left edge of detection window)
%         cc - correlation values of detection.

% Author: Dane Ketner, Alaska Volcano Observatory


%% CHECK REQUIRED INPUTS
if ~isa(erw,'waveform')
    error('erw_corr: Input argument ''erw'' must be a waveform object')
elseif ~isa(ds,'datasource')
    error('erw_corr: Input argument ''ds'' must be a datasource object')
end

%% DEFAULT PROPERTIES
start = get(erw,'start');
add_th = 0.75; 
sav_th = 0.6; 
dist = .5;       % 12 hours
block = 3/24;    % 3 hours
ror = 0.1;    
bpf = [1 15];
ploterw = 1;
scnl = get(erw,'scnlobject');

%% USER-DEFINED PROPERTIES
if (nargin > 2)
   v = varargin(1:end);
   nv = nargin-2;
   if ~rem(nv,2) == 0
      error(['erw_corr: Arguments after erw and ds must appear in ',...
             'property name/val pairs'])
   end
   for n = 1:2:nv-1
      name = lower(v{n});
      val = v{n+1};
      switch name
         case 'start' 
            start = val;
         case 'add_th' 
            add_th = val;
         case 'sav_th' 
            sav_th = val;
         case 'dist' 
            dist = val;            
         case 'block' 
            block = val;
         case 'ror' 
            ror = val;
         case 'bpf'   
            bpf = val;
         case 'plot'   
            ploterw = val;
         case 'scnl'   
            scnl = val;
         otherwise
            error('erw_corr: Property name not recognized')
      end
   end
end

%% INITIALIZATIONS

sd = get(erw,'data');  % erw data
sl = length(sd);       % erw length
tt = [];               % output times
cc = [];               % output corr values
plt_inc = 1;           % plot increment, update plot after every plt_inc events
plt_nxt = plt_inc      % next plot action will occur after event plt_nxt
fh = figure;
ax = axes;

%% DETECT EVENTS BACKWARDS THROUGHT TIME
disp('Detecting events backwards from start time')
pause(0.1)
t1 = start;
d = 0;
while d < dist
    t2 = t1;
    t1 = t1-block;
    w = get_w(ds,scnl,t1,t2);
    w = filt(w,'bp',bpf);
    if ~isempty(w)
        d = get(w,'data');
        l = length(d);
        tv = get(w,'timevector');
        flag = 0;
        wb_h = waitbar(0);
        for k = l-sl:-1:1; % Number of slide increments
            tmp = corrcoef(d(k:k+sl-1),sd);
            tmp = tmp(1,2);
            if (tmp > sav_th) && (flag == 0)
                flag = 1;
                X = [tmp k];
            elseif (tmp > sav_th) && (flag == 1)
                X = [X; tmp k];
            elseif (tmp < sav_th) && (flag == 1)
                flag = 0;
                [max_val ref] = max(X(:,1));
                max_ref = X(ref,2);
                cc = [max_val cc];
                tt = [tv(max_ref) tt];
                if max_val > add_th
                    sd = (1-ror)*sd + ror*d(max_ref:max_ref+sl-1);
                end
                clear X max_ref max_val
            end
            if rem(k,100)==0
                waitbar(k/(l-sl),wb_h,['Time: ',datestr(tv(k)),' Number of Detections: ',num2str(length(tt))])
            end
            if length(tt)==plt_nxt
                plt_nxt = plt_nxt + plt_inc;
                cla(ax)
                plot(sd)
            end
        end
    end
    if isempty(tt)
        d = start-t1;
    elseif ~isempty(tt)
        d = tt(1)-t1;
    end
end
delete(wb_h)

%% DETECT EVENTS FORWARDS THROUGHT TIME
disp('Detecting events forwards from start time')
pause(0.1)
sd = get(erw,'data');
t2 = start;
d = 0;
while d < dist
    t1 = t2;
    t2 = t2+block;
    w = get_w(ds,scnl,t1,t2);
    w = filt(w,'bp',bpf);
    if ~isempty(w)
        d = get(w,'data');
        l = length(d);
        tv = get(w,'timevector');
        flag = 0;
        wb_h = waitbar(0);
        for k = 1:l-sl % Number of slide increments
            tmp = corrcoef(d(k:k+sl-1),sd);
            tmp = tmp(1,2);
            if (tmp > sav_th) && (flag == 0)
                flag = 1;
                X = [tmp k];
            elseif (tmp > sav_th) && (flag == 1)
                X = [X; tmp k];
            elseif (tmp < sav_th) && (flag == 1)
                flag = 0;
                [max_val ref] = max(X(:,1));
                max_ref = X(ref,2);
                cc = [max_val cc];
                tt = [tv(max_ref) tt];
                if max_val > add_th
                    sd = (1-ror)*sd + ror*d(max_ref:max_ref+sl-1);
                end
                clear X max_ref max_val
            end
            if rem(k,100)==0
                waitbar(k/(l-sl),wb_h,['Time: ',datestr(tv(k)),' Number of Detections: ',num2str(length(tt))])
            end
            if length(tt)==plt_nxt
                plt_nxt = plt_nxt + plt_inc;
                cla(ax)
                plot(sd)
            end
        end
    elseif t1 > now % detected up until the current time (stop)
        d = dist;
    else
        % Try next block
    end
    if isempty(tt)
        d = t1-start;
    elseif ~isempty(tt)
        d = t1-tt(end);
    end
end
delete(wb_h)
%delete(fh)
