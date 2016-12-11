%MSEMS_PROGRAM_MANUAL: Same as sems_program but without a GUI                 
%
%        ds          - Data source
%        scnl        - SCNL object
%        t_start     - Start time
%        t_end       - End time
%        gen_hel     - Generate helicorder [1x1 boolean]
%        hel_min     - Helicorder trace length [1x1 double]
%        get_events  - Get events [1x1 boolean]
%        plot_events - Plot events on helicoreder [1x1 boolean] 
%        plot_vlp    - Plot VLP [1x1 boolean]
%        vlp_rng     - VLP bandpass range (period in s) [1x2 double]
%        edp         - Event detection parameters [1x7 double]
%                      =[cal sta lta on off skp mnd]
%                       cal - calibration scale
%                       sta - short-time-average window (seconds)
%                       lta - long-time-average window (seconds)
%                       on  - STA/LTA turn-on threshold
%                       off - STA/LTA turn-off threshold
%                       skp - skip amount after end of event (seconds)
%                       mnd - minimum duration of event (seconds)
%        event_ops   - Event-based plotting operations [1x4 boolean]
%                      =[es fi rms pf]
%                       es  - event spacing
%                       fi  - event frequency index
%                       rms - event root mean square
%                       pf  - event peak frequency
%                        
%OUTPUTS: w - waveform object specified by ds, scnl, t_start, t_end
%         events - detected event waveform object array specified by edp 

%% 
%host = 'pubnmi1.wr.usgs.gov';
%port = 16011;


host = 'avovalve01.wr.usgs.gov';
port = 16022;
ds = datasource('winston',host,port);

station = 'REF';
channel = 'EHZ';
network = 'AV';
scnl = scnlobject(station,channel,network);

t_start = datenum([2009 01 30 22 40 00]);
t_end = datenum([2009 01 30 22 50 00]);

% gen_hel = 1;
% hel_min = 10;
% get_events = 1;
% plot_events = 1;
% plot_vlp = 0;
% vlp_rng = [10 100];
% 
% sta = 1;
% lta = 8;
% on = 1.8;
% off = 1.6;
% skp = 2;
% mnd = 1.5;
% edp = [sta lta on off skp mnd];

% es = 0;
% fi = 0;
% rms = 0;
% pf = 0;
% event_ops = [es fi rms pf];

duration = (t_start - t_end); % Duration in decimal days

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if duration > 0.5 % Is time span greater than 12 hours?
   time_n = floor(duration/0.5);    % Number of full 12 hour blocks
   time_r =  rem(duration,0.5);     % Remaining time after last block
   for n=1:time_n
      t1 = datestr(t_start+(n-1)*0.5,0);
      t2 = datestr(t_start+(n)*0.5,0);
      w(1,n) = waveform(ds,scnl,t1,t2);
   end
   if time_r > 0
      t1 = t2;
      t2 = datestr(t_end,0);
      n=time_n+1;
      w(1,n) = waveform(ds,scnl,t1,t2);
   end
   w = combine(w);
elseif duration <= 0.5
   t1 = datestr(t_start,0);
   t2 = datestr(t_end,0);
   w = waveform(ds,scnl,t1,t2);  
   events = waveform();
end

% w = zero_gaps(w); % Find and replace gaps in data with zeros
% 
% if (gen_hel == 1)&&(get_events == 1)&&(plot_events == 1)&&(plot_vlp == 1)
%   events = sta_lta(w,edp,'wfa'); 
%   helicorder(w,hel_min,events,vlp_rng)
% elseif (gen_hel == 1)&&(get_events == 1)&&(plot_events == 1)&&(plot_vlp == 0)
%   events = sta_lta(w,edp,'wfa');
%   helicorder(w,hel_min,events)    
% elseif (gen_hel == 1)&&(plot_events == 0)&&(plot_vlp == 1)
%   helicorder(w,hel_min,vlp_rng)
% elseif (gen_hel == 1)&&(plot_events == 0)&&(plot_vlp == 0)
%   helicorder(w,hel_min)  
% elseif (gen_hel == 0)&&(get_events == 1)
%   events = sta_lta(w,edp,'wfa');
% end
% 
% op_n = sum(event_ops); % total number of event operations (subplots)
% if op_n > 0
%    figure
%    title_str = ['[',get(w,'station'),' ',get(w,'channel'),' ',...
%                 get(w,'network'),'] Detected Events' ];
%    op_c = 1;           % current subplot
%    if es == 1
%       subplot(op_n,1,op_c)
%       event_space(events,'m','plot')
%       op_c = op_c+1;
%       title(title_str)
%    end
%    if fi == 1
%       subplot(op_n,1,op_c)
%       freq_index(events,[1,2],[10,20],'plot','fft');
%       if op_c == 1
%          title(title_str)
%       end
%       op_c = op_c+1;
%    end
%    if rms == 1
%       subplot(op_n,1,op_c)
%       event_rms(events,'plot')
%       if op_c == 1
%          title(title_str)
%       end
%       op_c = op_c+1;
%    end
%    if pf == 1
%       subplot(op_n,1,op_c)
%       peak_freq(events,'plot','fft');
%       if op_c == 1
%          title(title_str)
%       end
%    end
%    xlabel(['Start ',datestr(t_start,0),' (UTC)'])
% end
% 
% %%%%%%%%%%%%%%%% Split long wave times into 12 hour blocks %%%%%%%%%%%%%%%%
% 
clear host port ds station channel network scnl t_start t_end gen_hel...
hel_min get_events plot_events plot_vlp vlp_rng cal sta lta on off skp ...
mnd edp es fi rms pf event_ops t_start_ser t_end_ser duration t1 t2 op_n
