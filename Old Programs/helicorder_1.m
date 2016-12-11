function helicorder(varargin) 
%
%HELICORDER: Generates a helicorder with detected event and VLP overlay.
%            Allows for interactive selection and viewing of highlighted
%            events.
%
%USAGE: helicorder(wave,tra_w_m) 
%       helicorder(wave,events,tra_w_m) 
%       helicorder(wave,tra_w_m,vlp_rng) 
%       helicorder(wave,events,tra_w_m,vlp_rng)
%
%DIAGRAM:
%                       /\      /\  
%    _____/\  _________/  \    /  \  /\  /\_______/\  _________/\  ___  
%           \/             \  /    \/  \/           \/           \/    
%                           \/
%                      |_______Event_______|
%    |________________________________________Trace__________________|
%
%INPUTS: wave    - a waveform object to be plotted on multiple helicorder
%                  trace lines
%        events  - a waveform object array of detected events from 'wave'
%        tra_w_m - an integer value specifying trace width (in minutes)
%        vlp -     plot low-pass VLP overlay onto helicorder (period in s)
%
%OUTPUTS: generates a figure, no output arguments
%


if nargin > 0
   if isa(varargin{1}, 'waveform')
      wave = varargin{1};
   else
       return
   end
end

switch nargin
   case 2 % Basic helicorder plot
      tra_w_m = varargin{2};
      events = [];
      vlp_rng = [];
   case 3 % Helicorder with event overlay
      if isa(varargin{2}, 'waveform')
         events = varargin{2};
         tra_w_m = varargin{3};
         vlp_rng = [];
      else % Helicorder with VLP overlay
         tra_w_m = varargin{2};
         vlp_rng = varargin{3};
         events = [];
      end 
   case 4 % Helicorder with event & VLP overlay
      events = varargin{2};
      tra_w_m = varargin{3};
      vlp_rng = varargin{4};
end

e_l = length(events);
w_d = get(wave,'data');                 % Wave data vector
w_l = get(wave,'data_length');          % Wave data length (data points)
w_t = get(wave,'timevector');           % Wave time vector
Fs = get(wave,'freq');                  % Sampling frequency
if (e_l~=0)                             % Is the events array non-empty?
   events_d = get(events,'data');       % Events data array    
   events_l = get(events,'data_length');% Events length array (data points)    
   events_t = get(events,'timevector'); % Events time array
   ce_n = 1;                            % Current event number
   ce_d = events_d(ce_n);               % Current event data 
   ce_l = events_l(ce_n);               % Current event length(data points)
   ce_t = events_t(ce_n);               % Current event time
   if iscell(ce_d)
      ce_d = ce_d{:};
   end
   if iscell(ce_t)
      ce_t = ce_t{:};
   end
end
max_w = max(abs(w_d));     % Largest data point value
trace_l = Fs*60*tra_w_m;   % Trace length (data points)
color = 1;                 % Trace color alternator

if ~isempty(vlp_rng)
    f_vlp = filterobject('B',1./vlp_rng,2); % 2 pole low-pass butterworth
    w_vlp = filtfilt(f_vlp,wave);
else
    w_vlp = [];
end

%%%%%%%%%%%%%% Plot helicorder traces alternation blue/black %%%%%%%%%%%%%%

figure('Name','Helicorder','doublebuffer','on',...
       'NumberTitle','off')
h = axes('Position',[0,0,1,1]);
hold on
lm = .1;                             % Left Margin
rm = .05;                            % Right Margin
tm = .05;                            % Top Margin
bm = .05;                            % Bottom Margin
box_pos = [lm bm 1-lm-rm 1-bm-tm];   % Helicorder boarders
h_box = axes('Position',box_pos);    % Trace axes object handle array
axis off
n_traces = floor(w_l/trace_l);       % Number of rows (traces) in helicorder
trace_spa = (1-tm-bm)/(n_traces+1);  % Trace spacing (normalized to axis h)
trace_w = 1-lm-rm;                   % Trace width (normalized to axis h)
trace_h = trace_spa*4;               % Trace height (normalized to axis h)

for n = 1:n_traces
   trace_cen = 1-tm-trace_spa*n;                      % Trace center location (normalized to axis h)
   trace_bot = trace_cen-trace_h/2;                   % Trace bottom location (normalized to axis h)
   trace_pos(n,:)=[lm, trace_bot, trace_w, trace_h];  % Trace axes positions vector
   h_trace(n) = axes('Position',trace_pos(n,:));      % Trace axes object handle array
   trace(n) = extract(wave,'INDEX',(n-1)*trace_l+1,n*trace_l); % Trace waveform
   trace(n) = demean(trace(n));
   if color==1                                        %
      plot(trace(n),'xunit','m','color','k')          % Plot trace black
      xlim([0 tra_w_m])                               %
      ylim([-max_w max_w])                            %
   else                                               %
      plot(trace(n),'xunit','m','color','b')          % Plot trace blue
      xlim([0 tra_w_m])                               %
      ylim([-max_w max_w])                            %
   end                                                %
   
%%%%%%%%%%%%% Plot VLP signal in red over blue/black traces %%%%%%%%%%%%%%%

if ~isempty(w_vlp)
    hold on
    h_vlp_trace(n) = h_trace(n);      % Trace axes object handle array
    vlp_trace(n) = extract(w_vlp,'INDEX',(n-1)*trace_l+1,n*trace_l); % VLP
    plot(vlp_trace(n),'xunit','m','color','r')          % Plot VLP in red
    xlim([0 tra_w_m])                               %
    ylim([-max_w max_w])                            %
end
    
%%%%%%%%%%%%%%%%%%%%%%% Plot time axes (left side)%%%%%%%%%%%%%%%%%%%%%%%%%    
    
   time_pos(n,:)=[0, trace_bot, lm, trace_h];     % Time axes positions vector
   h_time(n) = axes('Position',time_pos(n,:));    % Time axes object handle array
   trace_time = get(trace(n),'timevector');     % Time 
   time_text(n) = text(.5,.5,datestr(trace_time(1),'HH:MM:SS'),...% Text object 
   'VerticalAlignment','middle','HorizontalAlignment','center');  
   m=1;
     
%%%%%%%%%%%%%%% Plot events in red over blue/black traces %%%%%%%%%%%%%%%%%

   if ~isempty(events)                                 % Is the events array non-empty?
      while (m <= trace_l)&&(ce_n <= e_l)   %
         if w_t((n-1)*trace_l+m,1)==ce_t(1)            % Found start of event within current trace line
            event_w = trace_w/(trace_l/ce_l);          % Event width (normalized to axis h)
            event_h = trace_h*max(abs(ce_d))/max_w;    % Event height (normalized to axis h)
            event_bot = trace_cen-event_h/2;           % Event bottom location (normalized to axis h)
            event_pos(ce_n,:)=[lm+(m/trace_l)*trace_w, trace_bot,... % Event axes positions vector
                                  event_w, trace_h];                 %
            h_event(ce_n) = axes('Position',event_pos(ce_n,:));   % Event axes object handle array
            if (m+ce_l)<=(trace_l)                        % Does event fit on current trace?
               plot(events(ce_n),'xunit','s','Color','r') % Plot event in red over current trace
               xlim([1 ce_l/Fs])                          %
               ylim([-max_w max_w])                       %
            else                                          % Does event carry over onto next trace? 
               plot(events(ce_n),'xunit','s','Color','r') % Someday handle split events...
               xlim([1 ce_l/Fs])                          %
               ylim([-max_w max_w])                       %
            end
            if (ce_n < e_l)
               ce_n = ce_n+1;                      % Current event
               ce_d = events_d(ce_n);              % Current event data vector
               ce_l = events_l(ce_n);              % Current event length (data points)
               ce_t = events_t(ce_n);              % Current event time
               if iscell(ce_d)
                  ce_d = ce_d{:};
               end
               if iscell(ce_t)
                  ce_t = ce_t{:};
               end
            end
         end
      m = m+1;
      end
   end
color = color*-1;
end

h_title = axes('Position',[0,1-tm,1,tm]);
title_text =...
text(.5,.5,['[',get(wave,'station'),' ',get(wave,'channel'),' ',...
get(wave,'network'),' ',datestr(get(wave,'start'),'dd-mmm-yyyy'),']'],...
'FontSize',18,'VerticalAlignment','middle','HorizontalAlignment','center');  

set(h,'Visible','off')
set(h_trace,'Visible','off')
% set(h_vlp_trace,'Visible','off')
set(h_time,'Visible','off')
set(h_title,'Visible','off')

%%%%%%%%%%%%%%%%%%%%% Make event overlay interactive %%%%%%%%%%%%%%%%%%%%%%

if e_l~=0
   lines = findobj(h_event,'Type','line');
   set(lines,'HitTest','on','ButtonDownFcn',@buttonDown)
   for n = 1:max(size(lines))
       set(lines(n),'Tag',num2str(n))
   end
   set(h_event,'Visible','off')
end 

function buttonDown(click_event, eventdata)
    cen = str2double(get(click_event,'Tag')); % Get clicked event number
    event = events(cen);                      % Get event wave
    warning off
    hht_vs_fft(event,[0 .5])  % Event clicked functions go here
    event_view(event,[1 1])
    warning on
end

end