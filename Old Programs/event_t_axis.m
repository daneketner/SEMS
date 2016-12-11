function [xtic_loc xtic_lab] = event_t_axis(events,max_tic) 
%
%EVENT_T_AXIS: Return 2 arrays: x-axis (date/time) labels and locations of
%              labels from within a series of discrete events. event_t_axis
%              handles events spanning multiple hours to multiple months
%
%INPUTS: events - A waveform object array of detected events
%        max_tic - Approximate max number of x-axis ticks
%        
%OUTPUTS: xtic_loc - Location of x-axis ticks i.e.([20 39 57 91...])
%         xtic_lab - Labels for xtic_loc i.e.([01/12 01/13 01/14 01/15...])

nd=0; nh=0; %Initialized new day and new hour counters
new_day_loc = [];  % Location of new days in event series
xtic_loc = [];
xtic_lab = [];
for n = 1:length(events)-1
    t1 = get(events(n),'start');
    t2 = get(events(n+1),'start');
    if floor(t2)>floor(t1)
        nd=nd+1;               % New day counter
        new_day_loc(nd,1) = n;
        new_day_lab{nd,1} = datestr(floor(t2),'mm/dd'); % Date Label
        nh=nh+1;
        xtic_loc(nh,1) = n;    % Tick location
        xtic_lab{nh,1} = datestr(floor(t2),'mm/dd'); % Date Label
    elseif floor(t2*24)>floor(t1*24)
        nh=nh+1;               % New hour counter
        xtic_loc(nh,1) = n;    % Tick location
        xtic_lab{nh,1} = datestr(floor(t2*24)/24,'HH:MM'); % Date Label
    end
end

if nd > max_tic  % Number of days > max_tic?
   skpd = floor(nd/max_tic);
   clear xtic_loc xtic_lab
   for n = 1:floor(nd/skpd)
      xtic_loc(n) = new_day_loc(n*skpd);
      xtic_lab(n) = new_day_lab(n*skpd);
   end
elseif nd > max_tic/2
   cnt = 1;
   for n=1:nh
% 01/12, 12:00, 01/13, 12:00, 01/14, 12:00...
       if strcmp(xtic_lab{n},'12:00')||sum(xtic_lab{n}=='/')
          temp_loc(cnt) = xtic_loc(n);
          temp_lab(cnt) = xtic_lab(n);
          cnt = cnt + 1;
       end
   end
   xtic_loc = temp_loc;
   xtic_lab = temp_lab;
elseif nd > max_tic/3
   cnt = 1;
   for n=1:nh
% 01/12, 08:00, 16:00, 01/13, 08:00, 16:00, 01/14...
       if strcmp(xtic_lab{n},'08:00')||strcmp(xtic_lab{n},'16:00')||...
          sum(xtic_lab{n}=='/'),
          temp_loc(cnt) = xtic_loc(n);
          temp_lab(cnt) = xtic_lab(n);
          cnt = cnt + 1;
       end
   end
   xtic_loc = temp_loc;
   xtic_lab = temp_lab;
elseif nd > max_tic/4
   cnt = 1;
   for n=1:nh
% 01/12, 06:00, 12:00, 18:00, 01/13, 06:00, 12:00, 18:00, 01/14...
       if strcmp(xtic_lab{n},'06:00')||strcmp(xtic_lab{n},'12:00')||...
          strcmp(xtic_lab{n},'18:00')||sum(xtic_lab{n}=='/'),
          temp_loc(cnt) = xtic_loc(n);
          temp_lab(cnt) = xtic_lab(n);
          cnt = cnt + 1;
       end
   end
   xtic_loc = temp_loc;
   xtic_lab = temp_lab;
elseif nd > max_tic/6
   cnt = 1;
   for n=1:nh
% 01/12, 04:00, 08:00, 12:00, 16:00, 20:00, 01/13...
       if strcmp(xtic_lab{n},'04:00')||strcmp(xtic_lab{n},'08:00')||...
          strcmp(xtic_lab{n},'12:00')||strcmp(xtic_lab{n},'16:00')||...
          strcmp(xtic_lab{n},'20:00')||sum(xtic_lab{n}=='/'),
          temp_loc(cnt) = xtic_loc(n);
          temp_lab(cnt) = xtic_lab(n);
          cnt = cnt + 1;
       end
   end
   xtic_loc = temp_loc;
   xtic_lab = temp_lab;
elseif nd > max_tic/8
   cnt = 1;
   for n=1:nh
% 01/12, 03:00, 06:00, 09:00, 12:00, 15:00, 18:00, 21:00, 01/13...      
       if strcmp(xtic_lab{n},'03:00')||strcmp(xtic_lab{n},'06:00')||...
          strcmp(xtic_lab{n},'09:00')||strcmp(xtic_lab{n},'12:00')||...
          strcmp(xtic_lab{n},'15:00')||strcmp(xtic_lab{n},'18:00')||...          
          strcmp(xtic_lab{n},'21:00')||sum(xtic_lab{n}=='/'),
          temp_loc(cnt) = xtic_loc(n);
          temp_lab(cnt) = xtic_lab(n);
          cnt = cnt + 1;
       end
   end
   xtic_loc = temp_loc;
   xtic_lab = temp_lab;
elseif nd > max_tic/12
   cnt = 1;
   for n=1:nh
% 01/12, 02:00, 04:00, 06:00, 08:00, 10:00, 
% 12:00, 14:00, 16:00, 18:00, 20:00, 01/13...           
       if strcmp(xtic_lab{n},'02:00')||strcmp(xtic_lab{n},'04:00')||...
          strcmp(xtic_lab{n},'06:00')||strcmp(xtic_lab{n},'08:00')||...
          strcmp(xtic_lab{n},'10:00')||strcmp(xtic_lab{n},'12:00')||...    
          strcmp(xtic_lab{n},'14:00')||strcmp(xtic_lab{n},'16:00')||...
          strcmp(xtic_lab{n},'18:00')||strcmp(xtic_lab{n},'20:00')||...           
          strcmp(xtic_lab{n},'22:00')||sum(xtic_lab{n}=='/'),
          temp_loc(cnt) = xtic_loc(n);
          temp_lab(cnt) = xtic_lab(n);
          cnt = cnt + 1;
       end
   end
   xtic_loc = temp_loc;
   xtic_lab = temp_lab;
end