%LOG EVENTS:                

host = 'avovalve01.wr.usgs.gov';
port = 16022;
ds = datasource('winston',host,port);

station = 'REF';
channel = 'EHZ';
network = 'AV';
scnl = scnlobject(station,channel,network);

year = 2009;
mo = 01;
for da = 01:01;

t_start = [year mo da 00 00 00];
t_end = [year mo da+1 00 00 00];

get_events = 1;

cal = 6;
sta = 1;
lta = 8;
on = 1.8;
off = 1.6;
mnd = 1.5;
edp = [cal sta lta on off mnd];

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

t_start_ser = datenum(t_start); 
t_end_ser = datenum(t_end);
duration = (t_end_ser - t_start_ser); % Duration in decimal days

if duration > 0.5 % Is time span greater than 12 hours?
   time_n = floor(duration/0.5);    % Number of full 12 hour blocks
   time_r =  rem(duration,0.5);     % Remaining time after last block
   for n=1:time_n
      t1 = datestr(t_start_ser+(n-1)*0.5,0);
      t2 = datestr(t_start_ser+(n)*0.5,0);
      fprintf('*')
      w(1,n) = waveform(ds,scnl,t1,t2);
   end
   if time_r > 0
      t1 = t2;
      t2 = datestr(t_end_ser,0);
      n=time_n+1;
      w(1,n) = waveform(ds,scnl,t1,t2);
      w(1,n) = resample(w(1,n),'builtin',crunch);
   end
   w = combine(w);
elseif duration <= 0.5
   t1 = datestr(t_start_ser,0);
   t2 = datestr(t_end_ser,0);
   w = waveform(ds,scnl,t1,t2);  
end

w = zero_gaps(w); % Find and replace gaps in data with zeros
events = sta_lta(w,edp); 

savdir = ['C:\RED_Detected_Events\',num2str(year,'%04d'),'\',...
        num2str(mo,'%02d'),'\',num2str(da,'%02d'),'\',station,'_',channel];
save(savdir,'events'),clc
disp(['saved ',station,'_',channel,' to ','C:\RED_Detected_Events\',...
   num2str(year,'%04d'),'\',num2str(mo,'%02d'),'\',num2str(da,'%02d')])
clear w events               
end
%%   
% Code for swapping start/stop times for envents with start times that take
% place after stop times (reversed)

for m = 1:numel(e_sst)
   for n = 1:size(e_sst{m},1)
      if e_sst{m}(n,1) > e_sst{m}(n,2)
         temp = e_sst{m}(n,1);
         e_sst{m}(n,1) = e_sst{m}(n,2);
         e_sst{m}(n,2) = temp;
         disp('Flipping it')
      end
   end
end
%%
if ~isempty(new_sst)
   if (new_sst(1)~=H.e_sst(e_n,1))||(new_sst(2)~=H.e_sst(e_n,2))
      H = deleteEventFromTrace(H,e_n);
      H.e_sst(e_n,:) = new_sst;
      H = drawEventOntoTrace(H,e_n);
   end
else
   H = deleteEventFromTrace(H,e_n);
   H.e_sst(e_n,:) = [];
end
%%
function e_n = whichEvent(H,t)
   for k = 1:length(H.e_sst)
      if t>=H.e_sst(k,1) && t<=H.e_sst(k,2)
         e_n = k;
      end
   end
%%
function H = deleteEventFromTrace(H,e_n)
   for n = 1:numel(e_n)
      ev_t1 = H.e_sst(e_n,1); % Current event start time
      ev_t2 = H.e_sst(e_n,2); % Current event end time
      nanEvent = extract(H.wave,'time',ev_t1,ev_t2)*NaN; % event*NaN
      tr = H.trace_red;       % Red trace waveforms
      for m = 1:numel(tr)     % Number of traces
         ct_t1 = get(tr(m),'start'); % Current trace start time
         ct_t2 = get(tr(m),'end');   % Current trace end time
         if m < numel(tr)
            nt_t1 = get(tr(m+1),'start'); % Next trace start time
            nt_t2 = get(tr(m+1),'end');   % Next trace end time
         end
         if ev_t1 >= ct_t1      % Event start after trace start?
            if ev_t2 <= ct_t2   % Event on one trace
               dp = 1/24/60/60/H.Fs; 
               ll = extract(tr(m),'time',ct_t1,ev_t1-dp); % Left of event
               rr = extract(tr(m),'time',ev_t2+dp,ct_t2); % Right of event
               tmp = [ll; nanEvent; rr];
               H.trace_red(m) = combine(tmp); % Trace with event removed
               delete(H.trace_red_h(m));
               H.trace_red_h(m) = plot(H.trace_red(m),'color','r','xunit','minutes'); 
               set(H.trace_red_h,'HitTest','on','ButtonDownFcn',{@redTraClick,H})
               set(H.trace_red_h(m),'Tag',num2str(m))
            elseif (ev_t2 <= nt_t2) && (m < numel(tr)) % Event on 2 traces
               dp = 1/24/60/60/H.Fs; 
               ev_p1 = extract(nanEvent,'time',ev_t1,ct_t2); % Event Part 1
               ev_p2 = extract(nanEvent,'time',nt_t1,ev_t2); % Event Part 2
               ll = extract(tr(m),'time',ct_t1,ev_t1-dp); % Left of event (ct)
               rr = extract(tr(m+1),'time',ev_t2+dp,nt_t2);% Right of event (nt)
               tmp1 = [ll; ev_p1];
               tmp2 = [ev_p2; rr];
               H.trace_red(m) = combine(tmp1);   % ct w/ event removed
               H.trace_red(m+1) = combine(tmp2); % nt w/ event removed
               delete(H.trace_red_h(m));
               delete(H.trace_red_h(m+1));
               H.trace_red_h(m) = plot(H.trace_red(m),'color','r','xunit','minutes'); 
               H.trace_red_h(m+1) = plot(H.trace_red(m+1),'color','r','xunit','minutes'); 
               set(H.trace_red_h,'HitTest','on','ButtonDownFcn',{@redTraClick,H})
               set(H.trace_red_h(m),'Tag',num2str(m))
               set(H.trace_red_h(m+1),'Tag',num2str(m))
            end
         end
      end 
   end
%%      
function H = drawEventOntoTrace(H,e_n)
   for n = 1:numel(e_n)
      ev_t1 = H.e_sst(e_n,1); % Current event start time
      ev_t2 = H.e_sst(e_n,2); % Current event end time
      newEvent = extract(H.wave,'time',ev_t1,ev_t2); 
      tr = H.trace_red;       % Red trace waveforms
      for m = 1:numel(tr)     % Number of traces
         ct_t1 = get(tr(m),'start'); % Current trace start time
         ct_t2 = get(tr(m),'end');   % Current trace end time
         if m < numel(tr)
            nt_t1 = get(tr(m+1),'start'); % Next trace start time
            nt_t2 = get(tr(m+1),'end');   % Next trace end time
         end
         if ev_t1 >= ct_t1      % Event start after trace start?
            if ev_t2 <= ct_t2   % Event on one trace
               ll = extract(tr(m),'time',ct_t1,ev_t1); % Left of event
               rr = extract(tr(m),'time',ev_t2,ct_t2); % Right of event
               newEvent = newEvent/H.scale + H.off(m);
               tmp = [ll; newEvent; rr];
               H.trace_red(m) = combine(tmp); % Trace with event removed
               delete(H.trace_red_h(m));
               H.trace_red_h(m) = plot(H.trace_red(m),'color','r','xunit','minutes'); 
               set(H.trace_red_h,'HitTest','on','ButtonDownFcn',{@redTraClick,H})
               set(H.trace_red_h(m),'Tag',num2str(m))
            elseif (ev_t2 <= nt_t2) && (m < numel(tr)) % Event on 2 traces
               ev_p1 = extract(newEvent,'time',ev_t1,ct_t2); % Event Part 1
               ev_p1 = ev_p1/H.scale + H.off(m);
               ev_p2 = extract(newEvent,'time',nt_t1,ev_t2); % Event Part 2
               ev_p2 = ev_p2/H.scale + H.off(m+1);
               ll = extract(tr(m),'time',ct_t1,ev_t1); % Left of event (ct)
               rr = extract(tr(m+1),'time',ev_t2,nt_t2);% Right of event (nt)
               tmp1 = [ll; ev_p1];
               tmp2 = [ev_p2; rr];
               H.trace_red(m) = combine(tmp1);   % ct w/ event removed
               H.trace_red(m+1) = combine(tmp2); % nt w/ event removed
               delete(H.trace_red_h(m));
               delete(H.trace_red_h(m+1));
               H.trace_red_h(m) = plot(H.trace_red(m),'color','r','xunit','minutes'); 
               H.trace_red_h(m+1) = plot(H.trace_red(m+1),'color','r','xunit','minutes'); 
               set(H.trace_red_h,'HitTest','on','ButtonDownFcn',{@redTraClick,H})
               set(H.trace_red_h(m),'Tag',num2str(m))
               set(H.trace_red_h(m+1),'Tag',num2str(m))
            end
         end
      end 
   end
   refresh(H.fh)
%%
function events = amend_events(varargin)
%
%AMEND_EVENTS: Delete, Add, or Modify Events
%
%USAGE: events = amend_events(w,events,command,ref_type,ref)--(add or del)
%       events = amend_events(events,command,ref_type,ref)--(del only)
%
%A_events = amend_events(w,events,'add','data',[5000 7000])
%A_events = amend_events(w,events,'add','time',[t_1 t_2])
%---> Returns 'events' w/ an event added @ w(5000:7000) or (t1:t2)
%
%B_events = amend_events(w,A_events,'del','data',6000)
%B_events = amend_events(w,A_events,'del','data',[5000 7000])
%---> Referencing one data point or all datapoints in an event is
%     equivalent, entire event will be removed from set
%
%C_events = amend_events(w,A_events,'del','data',[5500 6500])
%---> Breaks event @ w(5000:7000) into 2 separate events:
%     first @ w(5000:5500), second @ w(6500:7000)
%
%D_events = amend_events(w,A_events,'del','data',[5000 5500],...
%                                   'add','data',[7000 7500])
%---> Event time changed to w(5500:7500)
%
%INPUTS: w -------- waveform object    
%        events --- waveform array of events to modify
%            REMAINING FORMAT: 
%            [command, ref_type, ref] (1x3*n)
%        command -- 'add','del'
%        ref_type - 'time' (Matlab vector of times)
%                   'data' (Reference datapoint from w)
%        ref ------ Event(s) referenced (depends on ref_type)
%
%OUTPUTS: events - Modified event waveform array

% Loop determines which argument is events, and which is w. If w is empty,
% then it is set as an empty waveform. The remaining arguments should be
% in [command, ref_type, ref] format

wav_arg = 2; % Initial assumption: 2 waveform arguments (w & events)
v1 = varargin{1};  v2 = varargin{2};
if isa(v1,'waveform') && isa(v2,'waveform')
   if length(v1)==1 && length(v2)>1      % Multiple Events
      w = v1; events = v2;
   elseif length(v2)==1 && length(v1)>1  % Multiple Events
      w = v2; events = v1;
   elseif length(v1)==1 && length(v2)==1 % Single Event
      l1 = get(v1,'data_length');
      l2 = get(v2,'data_length');
      if l1 > l2                    % Events and w determined by length
         w = v1; events = v2;
      elseif l2 > l1
         w = v2; events = v1;
      end
   else
      error('Waveform arguments incorrectly sized, w (1x1), events (nx1)')
   end
elseif isa(v1,'waveform') && ~isa(v2,'waveform')
   events = v1;
   w = waveform();
   wav_arg = 1;
elseif ~isa(v1,'waveform')
   error('First argument should be a waveform object')
end
rem_arg = nargin - wav_arg;

% Assign variable used later & check that number of remaining arguments is
% divisable by 3, and thusly, in [command, ref_type, ref] format

if ~isempty(w)
   ev_nan = event_war2nan(w, events); 
else
   ev_nan = event_war2nan(events);
end

dat_ev_nan = get(ev_nan,'data');
d_l = get(ev_nan,'data_length');
t_v = get(ev_nan,'timevector');
t1 = get(ev_nan,'start');
t2 = get(ev_nan,'end');
l_e = length(events);

R = rem(rem_arg,3);
if R ~= 0
   error(['All arguments following waveform argument should appear in ',...
          'groups of 3 with the format: [command, ref_type, ref]'])
end

% Master loop completed once for every set of [command, ref_type, ref] args
% The strategy employed is to convert all ref_types to 'time' before
% executing the action defined in 'command'

for n = 1:rem_arg/3
   arg1 = varargin{wav_arg+1+(3*n-3)};
   arg2 = varargin{wav_arg+2+(3*n-3)};
   arg3 = varargin{wav_arg+3+(3*n-3)};
   if strcmpi(arg1,'add')
      command = 1;
   elseif strcmpi(arg1,'del')
      command = -1;
   else
      error('Command argument can only include ''add'' or ''del''.')
   end
   if strcmpi(arg2,'data')||strcmpi(arg2,'time')
      ref_type = arg2;
   else
      error('ref_type argument can only be ''data'', or ''time''.')
   end
   if isnumeric(arg3)
      ref = arg3;
      if strcmp(ref_type,'data')
         if length(ref)==1 && (ref>=1) && (ref<=d_l) ||...
               length(ref)==2 && (ref(1)>=1) && (ref(1)<=d_l) &&...
               (ref(2)>=1) && (ref(2)<=d_l)
            ref = t_v(ref);
            ref_type = 'time';
         else
            error('Value for ''ref'' is out of bounds of w')
         end
      elseif strcmp(ref_type,'time')
         if length(ref)==1 && (ref>=t1) && (ref<=t2) ||...
               length(ref)==2 && (ref(1)>=t1) && (ref(1)<=t2) &&...
               (ref(2)>=t1) && (ref(2)<=t2)
         else
            error('Value for ''ref'' is out of bounds of w')
         end
      end
   end
   if (length(ref)==1) && (command == 1)
      error('When adding events, start and end times must be specified')
   elseif (length(ref)==1) && (command == -1)
      for k = 1:l_e
         if (get(events(n),'start')<=ref) && (get(events(n),'end')>=ref)
            del_k = k;
         end
      end
      events(del_k) = [];
   elseif (length(ref)==2)
      if ~isempty(w)
         if command == 1
            new_ev = extract(w,'time',ref(1),ref(2));
            dat_new_ev = get(new_ev,'data');
         end
      else
         if command == 1
            error('Cannot add event data if w is unspecified')
         end
      end
      k = 1;
      done = 0;
      while (done == 0)&&(k<length(t_v))
         if ref(1) == t_v(k)
            if command == 1
               adding = 1;
               kk = 1;
               while adding == 1
                  dat_ev_nan(k) = dat_new_ev(kk);
                  k = k+1; kk = kk+1;
                  if ref(2)<t_v(k)
                     adding = 0;
                     done = 1;
                  end
               end
            elseif command == -1
               deleting = 1;
               while deleting == 1
                  dat_ev_nan(k) = NaN;
                  k = k+1;
                  if ref(2)<t_v(k)
                     deleting = 0;
                     done = 1;
                  end
               end
            end
         end
         k = k+1;
      end
      ev_nan = set(ev_nan,'data',dat_ev_nan);
      events = event_nan2war(ev_nan);
   end
end % Master Loop
%%
function [t1,t2] = find_event(w,i,l_sta,thresh_l,thresh_r)
%
%FIND_EVENT: Find a seismic event containing the time instance t.
%            Algorithm similar to STA/LTA, but starts inside the events
%            and searches for the beginning and the end.
%
%USAGE: event = find_event(w,t,l_sta)
%
%INPUTS: w - waveform object    
%        t - time reference when an event is known to be occuring
%
%OUTPUTS: event - waveform of located event

w = bb_filt(w);
w = detrend(w);
w_d = abs(get(w,'data'));  % Absolute value of detrended data
sta = w_d*NaN;             % STA vector, all NaN with same length as w_d
d = floor(l_sta/2);        % Distance from STA window center to side
sta(i) = sum(w_d(i-d:i+d))/l_sta; % First entry into array 'sta'
sta_max = sta(i);          % Max value of 'sta' array
sta_min_l = sta(i);        % Min value of 'sta' left of sta(i)
sta_min_r = sta(i);        % Max value of 'sta' right of sta(i)
i_max = i;                 % Location of sta_max
i_min_l = i;               % Location of sta_min_l
i_min_r = i;               % Location of sta_min_r
il = i;                    % Left reference
ir = i;                    % Right reference
i_start = [];              % Start position
i_end = [];                % End position
start_found = 0;           %
end_found = 0;             %
both_found = 0;            %

while (both_found == 0)&&(il>d)&&(ir<length(w_d)-d)
   if start_found == 0;
      il = il - 1;                          % Increment left
      sta(il) = sum(w_d(il-d:il+d))/l_sta;  %
      if (sta(il)<sta_min_l)
         sta_min_l = sta(il);
         i_min_l = il;
      end
   end
   if end_found == 0;
      ir = ir + 1;                          % Increment right
      sta(ir) = sum(w_d(ir-d:ir+d))/l_sta;
      if (sta(ir)<sta_min_r)
         sta_min_r = sta(ir);
         i_min_r = ir;
      end
   end
   if (sta(il)>sta_max)
      sta_max = sta(il);
      i_max = il;
   end
   if (sta(ir)>sta_max)
      sta_max = sta(ir);
      i_max = ir;
   end
   if il < (ir - 10*l_sta)
      if start_found == 0
         if ((sta_min_l)*thresh_l < (sta_max)) &&...
               (max(sta(il:il+5*l_sta) < sta_min_l*1.3))
            start_found = 1;
            for ii = il:il+5*l_sta
               if sta(ii)<=sta_min_l*1.1
                  i_start = ii+d;
               end
            end
         end
      end
      if end_found == 0
         if ((sta_min_r)*thresh_r < (sta_max)) &&...
               (max(sta(ir-5*l_sta:ir) < sta_min_r*1.3))
            ii = ir-5*l_sta;
            while end_found == 0
               if sta(ii) <= sta_min_r*1.1
                  i_end = ii-d;
                  end_found = 1;
               else
                  ii = ii + 1;
               end
            end
         end
      end
      if (start_found == 1)&&(end_found == 1)
         both_found = 1;
         event = extract(w,'index',i_start,i_end);
         t1 = get(event,'start');
         t2 = get(event,'end');
      end
   end
end
if both_found == 0
   return
end