function helicorder_2(wave,tra_w_m,events)
%
%HELICORDER: Generates a helicorder with detected event and VLP overlay.
%            Allows for interactive selection and viewing of highlighted
%            events.
%
%USAGE: helicorder_2(wave,tra_w_m,events)
%       helicorder_2(wave,tra_w_m)
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

wav_d = get(wave,'data');               % Wave data vector
w_l = get(wave,'data_length');          % Wave data length (counts)
Fs = get(wave,'freq');                  % Sampling frequency

if length(events)~=0                    % Is the events array non-empty?
   ovr = event_war2nan(wave, events);   % Return wave w/ NaN non-events
   cnt = event_war2cnt(wave, events);   % Return CNT form
   cnt_d = get(cnt, 'data');            % event number if event
end

%%%%%%%%%%%%%% Plot helicorder traces alternation blue/black %%%%%%%%%%%%%%

figure                           % Helicorder figure
h = gca;                         % figure handle
color = 1;                       % Trace color alternator
trace_l = Fs*60*tra_w_m;         % Trace length (data points)
n_traces = floor(w_l/trace_l);   % Number of rows (traces) in helicorder
w_sca = (max(wav_d)-min(wav_d)); % Scale factor

for n = 1:n_traces
   offset(n) = .5+(n_traces-n)*.25; % where is trace plotted?
   trace(n) = extract(wave,'index',1+(n-1)*trace_l,n*trace_l)/w_sca +...
              offset(n);
   if length(events)~=0
     trace_red(n) = extract(ovr,'index',1+(n-1)*trace_l,n*trace_l)/w_sca...
                     + offset(n);
   end
   if color==1
      plot(trace(n),'color','k','xunit','minutes')% Plot trace black
   else
      plot(trace(n),'color','b','xunit','minutes')% Plot trace blue
   end
   if n == 1
      hold on
   end
   if length(events)~=0
      plot(trace_red(n),'color','r','xunit','minutes')% Plot event red
   end
   color = color*-1;
end

xlim([0 tra_w_m])
ylim([0 1+(n_traces-1)*.25])

k_b_line = findobj(h,'Type','line','-and',{'color','k','-or','color','b'});
set(k_b_line,'HitTest','on','ButtonDownFcn',@k_bButDown)
l_k_b = length(k_b_line);
for n = 1:l_k_b
   set(k_b_line(l_k_b-n+1),'Tag',num2str(n))
end

red_line = findobj(h,'Type','line','-and','color','r');
set(red_line,'HitTest','on','ButtonDownFcn',@redButDown)
l_red = length(red_line);
for n = 1:l_red
   set(red_line(l_red-n+1),'Tag',num2str(n))
end

set(gcf,'keypressFcn',@keyPress)
setappdata(gcf,'flag',0);        % Key pressed flag

function k_bButDown(click_tra, eventdata)
   trace_n = str2double(get(click_tra, 'Tag'));
   mouse = get(h,'currentpoint');
   % calculate the point nearest to the mouse click
   [val, pnt] = min( sqrt(...
      (get(click_tra,'xdata')-mouse(1,1)).^2 ...
      +(get(click_tra,'ydata')-mouse(1,2)).^2));
   ref = (trace_n-1)*trace_l+pnt;
   w1 = extract(wave,'index',ref-60*Fs,ref+60*Fs);
   new_event = find_event(w1,60*Fs,Fs,5,5);
   t1 = get(new_event,'start');
   t2 = get(new_event,'end');
   t = [t1 t2];
   events = amend_events(events,wave,'add','time',t);
   disp(['Event added, number of events: ', num2str(length(events))])
   scale_event = new_event/w_sca + offset(trace_n);
   temp = [trace_red(trace_n) scale_event];
   trace_red(trace_n) = combine(temp);
   plot(trace_red(trace_n),'color',[1 0 0],'xunit','minutes')
   cnt = event_war2cnt(wave, events);
end % k_bButDown

function redButDown(click_tra, eventdata)
   trace_n = str2double(get(click_tra, 'Tag'));
   mouse = get(h,'currentpoint');
   % calculate the point nearest to the mouse click
   [val, pnt] = min( sqrt(...
      (get(click_tra,'xdata')-mouse(1,1)).^2 ...
      +(get(click_tra,'ydata')-mouse(1,2)).^2));
   ref = (trace_n-1)*trace_l+pnt;
   e_n = cnt_d(ref);
   if(strcmpi(get(gcf,'CurrentKey'),'x')) % Delete Event
      if( getappdata(gcf,'flag') == 1)
         disp(['Removing event number ', num2str(e_n)])
         events(e_n) = [];
         cnt = event_war2cnt(wave, events); 
         cnt_d = get(cnt,'data');
         setappdata(gcf,'flag',0);   % reset flag
         red_dat = get(trace_red(trace_n),'data');
         k = pnt;
         while (~isnan(red_dat(k)))&&(k>1)
            k = k-1;
         end
         k = k+1;
         while (~isnan(red_dat(k)))
            red_dat(k)=NaN;
            k = k+1;
         end
         trace_red(trace_n) = set(trace_red(trace_n),'data',red_dat);
         set(click_tra,'ydata',red_dat);
      end
   else
      disp(['Event number ', num2str(e_n), ' selected']) % View Event
      event = events(e_n);
      hht_vs_fft(event,[0 .5])  % Event clicked functions go here
      event_view(event,[1 1])
   end
end % redButDown

function keyPress(src,evnt)
   setappdata(gcf,'flag',1);   % set flag
end % keyPress

end % helicorder_2



