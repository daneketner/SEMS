function [tt cc seed_out] = seed_corr2(seed,wave,start)

%SEED_CORR: Continuous forward and reverse time correlation detector. This
%   function takes input of waveform 'seed' and detects similar events by
%   correlating seed against continuous data. As new events are detected,
%   the seed waveform is evolved by adding a scaled version of the new
%   waveform to itself. The rate of replacement 'ror' determines how fast
%   the seed adapts according to the equation: seed = seed(1-ror)+w(ror) 
%   where 'w' is the newly detected waveform event. The variable 'ror' 
%   should be set between 0 and 1 to operate correctly. The lower ror is, 
%   the longer it will take to evolve i.e. (adaptability vs. stability).
%
%USAGE: [t cc seed_out] = seed_corr(seed,wave,start)
%
%INPUTS: seed - a waveform object used as the initial master waveform for 
%               detection via correlation. The length of seed will 
%               determine the length of the window being correlated.
%               *required 
%       start - if 1, search is performed forwards through time
%               if -1, search is performed backwards through time
%               if a time value is used, seach will begin at this time 
%               going both forwards and backwards through time.
%               *required
%         cth - correlation threshold, waveforms correlating above this
%               value will be recorded.
%               *default = .7
%       block - size of incremental waveform block over which to detect 
%               *default = .25 (days) or (6 hours)
%         ror - seed rate of replacement (between 0 and 1)
%               *default = .05        
%         bpf - bandpass filter limits for incoming continuous data
%               *default = [1 15]     
%OUTPUTS: tt - time values of detections (leftmost end of detection window)
%         cc - correlation values of detection.
%         seed_out - evolved waveform seed after final detection, if start
%               is 1 or -1, this will be a waveform of length 1. If start
%               is a time value, seed_out will be of length 2. In this
%               case, the resulting waveforms
%DIAGRAM
%                                      seed0
%                                        |
%                   seed-2       seed-1  |   seed+1        seed+2
%           [  w-2 ] <-- [  w-1 ] <-- [  w0  ] --> [  w+1 ] --> [  w+2 ]
%   start =    -1           -1           t            1            1
%
%  This diagram illustrates how seed detection is performed over multiple
%  blocks of waveform data. An initial seed waveform is used from block w0
%  which occurred at time t. This looks like:
%  [tt cc seed_out] = seed_corr(seed0,w0,t);
%  seed_out from this call results in 2 new seeds: seed-1 and seed+1
%  Next, blocks occurring before (w-1) and after (w+1) are searched:
%  [tt cc seed_out] = seed_corr(seed-1,w-1,-1);
%  [tt cc seed_out] = seed_corr(seed+1,w+1,1);
%  Detection of new waveform events can continue forwards and backwards
%  through time in this fashion.

% Author: Dane Ketner, Alaska Volcano Observatory
% $Date$
% $Revision$

%% DEFAULT PROPERTIES
cth = 0.7;
block = 6/24;
ror = 0.1;
bpf = [1 15];

%% USER-DEFINED PROPERTIES - COMING SOON!
fh = figure;
sd = get(seed,'data'); % seed data
sl = length(sd);       % seed length
tt = [];               % output times
cc = [];               % output corr values
plt_inc = 1;      % plot increment, update plot after every plt_inc events
plt_nxt = plt_inc; % next plot action will occur after event plt_nxt

% if start == 1
%     [tt cc seed_out] = seed_forward()
% elseif start == -1
%     [tt cc seed_out] = seed_backward()
% else
%     start = chk_t(start)

%% SLIDE SEED BACKWARDS THROUGHT TIME
%function seed_backwards()
disp('Backwards through time!'), pause(0.1)
t1 = start;
found = 1;
while found==1
    t2 = t1;
    t1 = t1-block;
    found = 0;
    w = extract(wave,'time',t1,t2);
    w = bp_filt(w,bpf);
    d = get(w,'data');
    l = length(d);
    tv = get(w,'timevector');
    flag = 0;
    wb_h = waitbar(0);
    for k = l-sl:-1:1; % Number of slide increments
        tmp = corrcoef(d(k:k+sl-1),sd);
        tmp = tmp(1,2);
        if (tmp > cth) && (flag == 0)
            found = 1;
            flag = 1;
            X = [tmp k];
        elseif (tmp > cth) && (flag == 1)
            X = [X; tmp k];
        elseif (tmp < cth) && (flag == 1)
            flag = 0;
            [max_val ref] = max(X(:,1));
            max_ref = X(ref,2);
            cc = [max_val cc];
            tt = [tv(max_ref) tt];
            sd = (1-ror)*sd + ror*d(max_ref:max_ref+sl-1);
            clear X max_ref max_val
        end
        if rem(k,100)==0
            waitbar(k/(l-sl),wb_h,['Time: ',datestr(tv(k)),' Number of Detections: ',num2str(length(tt))])
        end
        if length(tt)==plt_nxt
            plt_nxt = plt_nxt + plt_inc;
            plot(sd)
        end
    end
    %save('your_name_here.mat','tt','cc')
end
delete(wb_h)

%% Forwards through time
%function seed_forwards()
disp('Forwards through time!')
pause(0.1)
sd = get(seed,'data');
t2 = start;
found = 1;
while found==1
    t1 = t2;
    t2 = t2+block;
    found = 0;
    w = extract(wave,'time',t1,t2);
    w = bp_filt(w,bpf);
    d = get(w,'data');
    l = length(d);
    tv = get(w,'timevector');
    flag = 0;
    wb_h = waitbar(0);
    for k = 1:l-sl % Number of slide increments
        tmp = corrcoef(d(k:k+sl-1),sd);
        tmp = tmp(1,2);
        if (tmp > cth) && (flag == 0)
            found = 1;
            flag = 1;
            X = [tmp k];
        elseif (tmp > cth) && (flag == 1)
            X = [X; tmp k];
        elseif (tmp < cth) && (flag == 1)
            flag = 0;
            [max_val ref] = max(X(:,1));
            max_ref = X(ref,2);
            cc = [cc max_val];
            tt = [tt tv(max_ref)];
            sd = .95*sd + .05*d(max_ref:max_ref+sl-1);
            clear X max_ref max_val
        end
        if rem(k,100)==0
            waitbar(k/(l-sl),wb_h,['Time: ',datestr(tv(k)),' Number of Detections: ',num2str(length(tt))])
        end
        if length(tt)==plt_nxt
            plt_nxt = plt_nxt + plt_inc;
            plot(sd)
        end
    end
    %save('your_name_here.mat','tt','cc')
end
delete(wb_h)