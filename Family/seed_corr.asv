function [tt cc] = seed_corr(seed,ds,varargin)

%SEED_CORR: Continuous forward and reverse time correlation detector. This
%   function takes input of waveform 'seed' and detects similar events by
%   correlating seed against continuous data. As new events are detected,
%   the seed waveform is evolved by adding a scaled version of the new
%   waveform to itself. The rate of replacement 'ror' determines how fast
%   the seed adapts according to the equation: seed = seed(1-ror)+w(ror) 
%   where 'w' is the newly detected waveform event. The variable 'ror' 
%   should be set between 0 and 1 to operate correctly. The lower rate is, 
%   the longer it will take to evolve (adaptability vs. stability).
%
%USAGE: [t cc] = seed_corr(seed,ds,scnl)
%       [t cc] = seed_corr(seed,ds,scnl,prop_1,val_1,...)
%
%REQUIRED INPUTS: 
%   seed - a waveform object used as the initial master waveform for 
%          detection via correlation. The length of seed will determine the 
%          length of the window being correlated.
%   ds - datasource object from which to fetch waveforms
%   scnl - SCNL object
%   
%VALID PROP/VAL:
%   start - where in time to begin detection (this should probably be 
%           close to when the initial seed waveform occured). 
%           *default = start time of initial seed waveform
%   add_th - Add threshold, waveforms correlating above this threshold 
%            value will be recorded and added to the seed (0-1).
%            *default = .75
%   sav_th - Save threshold, waveforms correlating above this threshold 
%            value will be recorded but not added to the seed (0-1).
%            *default = .60
%   dist - Quit searching for events after they are seperated by this 
%          distance (in days) *default = .5
%   block - size of incremental waveform blocks (in days) over which to 
%           search for events *default = .25, or 6 hours
%   ror - seed rate of replacement (0-1) *default = .05        
%   bpf - bandpass filter limits for incoming waveform blocks
%         *default = [1 15] --> Note: no filtering of original seed    
%   plot - plot evolution of seed every time seed is updated (1 or 0)
%              *default = 1 (Plot on, this is fun to watch!)
%   scnl - SCNL obect of waveform blocks
%         *default = scnl object extracted from seed input
%OUTPUTS: tt - time values of detections (left edge of detection window)
%         cc - correlation values of detection.

% Author: Dane Ketner, Alaska Volcano Observatory
% $Date$
% $Revision$

%% CHECK REQUIRED INPUTS
if ~isa(seed,'waveform')
    error('seed_corr: Input argument ''seed'' must be a waveform object')
elseif ~isa(ds,'datasource')
    error('seed_corr: Input argument ''ds'' must be a datasource object')
end

%% DEFAULT PROPERTIES
start = get(seed,'start');
add_th = 0.75; 
sav_th = 0.6; 
dist = 1; % 24 hours
block = 3/24; % 3 hours
ror = 0.1;    
bpf = [1 15];
plotseed = 1;
scnl = get(seed,'scnlobject')

%% USER-DEFINED PROPERTIES
if (nargin > 2)
   v = varargin(1:end);
   nv = nargin-2;
   if ~rem(nv,2) == 0
      error(['seed_corr: Arguments after seed and ds must appear in ',...
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
            plotseed = val;
         case 'scnl'   
            scnl = val;
         otherwise
            error('seed_corr: Property name not recognized')
      end
   end
end

%% INITIALIZATIONS

sd = get(seed,'data'); % seed data
sl = length(sd);       % seed length
tt = [];               % output times
cc = [];               % output corr values
plt_inc = 1;      % plot increment, update plot after every plt_inc events
plt_nxt = plt_inc % next plot action will occur after event plt_nxt
fh = figure;
ax = axes;

%% SLIDE SEED BACKWARDS THROUGHT TIME
disp('Backwards through time!')
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

%% SLIDE SEED FORWARDS THROUGHT TIME
disp('Forwards through time!')
pause(0.1)
sd = get(seed,'data');
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
