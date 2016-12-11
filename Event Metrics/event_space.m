function spacing = event_space(events,unit,op) 
%
%EVENT_SPACE: Return array of inter-event spacing values.
%
%INPUTS: events - a waveform object array of detected events
%        unit   - string specifying units of 'spa' (s,m,h,d)
%        op     - operation: 'plot','logplot','val','logval'
%        
%OUTPUTS: spa - temporal spacing of events (1x(length(events)-1))

 switch lower(unit)
      case {'s','ss','sec','seconds'}
         scale = 1*24*60*60; % number of s in one day
         scale_lab = 'seconds';
      case {'m','mm','min','minutes'}
         scale = 1*24*60; % number of m in one day   
         scale_lab = 'minutes';
      case {'h','hr','hh','hours'}
         scale = 1*24; % number of h in one day 
         scale_lab = 'hours';
      case {'d','dd','days'}
         scale = 1; % number of d in one day
         scale_lab = 'days';
 end

ev_l = length(events);
spa = zeros(ev_l-1,1); % Event spacing vector (length(events)-1)
spa_l = length(spa);
for n = 1:spa_l
    t1 = get(events(n),'start');
    t2 = get(events(n+1),'start');
    spa(n,1) = (t2-t1)*scale;   % Event spacing (between start times)
end

x=get(events,'start');
x=x(1:end-1);

switch lower(op)
   case {'plot'} % plot linear event spacing (return no values)
      scatter(x,spa)
      dynamicDateTicks
      ylabel(['Event spacing (',scale_lab,')'])
      return
   case {'logplot'} % plot log event spacing (return no values)
      scatter(x,log10(spa))
      dynamicDateTicks
      ylabel(['Event spacing (Log_1_0',scale_lab,')'])
      return
   case {'val'} % return linear event spacing values (no plot)
      spacing = spa; 
      return
   case {'logval'} % return log event spacing values (no plot)
      spacing = log10(spa);    
      return   
 end
