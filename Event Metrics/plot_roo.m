function plot_roo(t,varargin) 

% Plot event                rate of occurance

%% DEFAULT PROPERTIES
if (nargin >= 1)
   per = 24; % Rate per hour
   tag = 'hour';
else
   return
end

%% USER-DEFINED PROPERTIES
if (nargin > 1)
   v = varargin;
   nv = nargin-2;
   if ~rem(nv,2) == 0
      error(['plot_roo: Arguments after wave must appear in ',...
             'property name/val pairs'])
   end
   for n = 1:2:nv-1
      name = lower(v{n});
      val = v{n+1};
      switch name
         case {'rate','time'}  % minute,hour,day,week
            switch val
               case {'m','min','minute'}
                  per = 24*60; % Rate per minute
                  tag = 'minute';
               case {'h','hr','hour'}
                  per = 24; % Rate per hour
                  tag = 'hour';
               case {'d','day'}
                  per = 1; % Rate per day
                  tag = 'day';
               case {'w','week'} 
                  per = 1/7; % Rate per week
                  tag = 'week';
            end
         otherwise
            error('plot_roo: Property name not recognized')
      end
   end
end

%%

st = t*per;         % t scaled by rate, days if per=1, default: per=24 (hours)
ft = floor(st);     % decimal values discarded
bt = ft(1):ft(end); 
br = zeros(1,length(bt)); % bin rate
for k = 1:length(bt)
   br(k) = sum(ft==bt(k));
end

%%
% st2 = t2*per;         % t scaled by rate, days if per=1, default: per=24 (hours)
% ft2 = floor(st2);     % decimal values discarded
% bt2 = ft2(1):ft2(end); 
% br2 = zeros(1,length(bt2)); % bin rate
% for k = 1:length(bt2)
%    br2(k) = sum(ft2==bt2(k));
% end

%%
figure
ax = gca;

%%
h = bar(bt/per,br,'grouped');
set(get(ax,'Ylabel'),'String',['Events per ',tag])
set(ax,'Ylim',[0 max(br)])
set(ax,'Xlim',[t(1) t(end)])
set(h,'FaceColor',[0 0 0])
set(h,'EdgeColor',[0 0 0])
dynamicDateTicks(ax)

%%
% hold on
% h2 = bar(bt2/per,br2,'grouped');
% set(h2,'FaceColor',[1 0 0])
% set(h2,'EdgeColor',[1 0 0])

%%

% [AX,H1,H2] = plotyy(bt/per,br,t,1:length(t),'bar','plot');
% set(get(AX(1),'Ylabel'),'String',['Events per ',tag])
% set(AX(1),'Ycolor',[0 0 0])
% set(AX(1),'Ylim',[0 max(br)])
% set(AX(1),'Xlim',[t(1) t(end)])
% set(H1,'FaceColor',[0 0 0])
% set(H1,'EdgeColor',[0 0 0])
% set(get(AX(2),'Ylabel'),'String','Cumulative Number of Events')
% set(AX(2),'Ycolor',[1 0 0])
% set(AX(2),'Ylim',[0 length(t)])
% set(AX(2),'Xlim',[t(1) t(end)])
% set(H2,'Color',[1 0 0])
% dynamicDateTicks(AX)
% linkaxes(AX,'x')