function plot_chrono2(FM,ind,colors)


%% PLOT VERTICAL LINES
% nex = numel(explosion);
% for m = 1:nex
%    line([explosion(m),explosion(m)],[0 1],'color','r')
% end

%% PLOT MULTIPLET CHRONOLOGY
nf = numel(ind);                % Number of families
tm = .025;                      % Axes Top Margin
bm = .025;                      % Axes Bottom Margin
gap = (1-tm-bm)*.2/(nf-1);      % Gap between rectangles 
h = (1-tm-bm-gap*(nf-1))/nf;    % Height of rectangles

for n = 1:nf
    trigmax(n) = max(FM(ind(n)).trig{1});
    trigmin(n) = min(FM(ind(n)).trig{1});
end
[v r] = sort(trigmin,'ascend');
for n = 1:nf                    % 1:number of families
   yts = 1; % Y-Tick Spacing
   if rem(n,yts)==0
   ylab{n/yts} = num2str(n,'%03.0f');      % Y-axis Family Label
   ypos(n/yts) = bm+(h+gap)*(n-1)+h/2;     % Y-axis Family Label Position
   end
   trig = FM(ind(r(n))).trig{1};
   % DRAW FAMILY RECTANGLE
   rectangle('Position',[min(trig),bm+(h+gap)*(n-1),max(trig)-min(trig)+1E-8,h],...
             'FaceColor',[1 1 1],'EdgeColor',colors(r(n),:));    
   % DRAW VERTICAL TICKS INSIDE FAMILY RECTANGLE FOR ALL INTERIOR MEMBERS
   for m = 2:numel(trig)-1       
      line([trig(m) trig(m)],[bm+(h+gap)*(n-1), bm+(h+gap)*(n-1)+h],'color',colors(r(n),:))
   end
end

set(gca,'YTick',ypos)
set(gca,'YTickLabel',ylab)
set(gca,'XGrid','on')
ylabel('MULTIPLET NUMBER')
xlabel('DATE')
dynamicDateTicks
ylim([0,1])
xlim([floor(min(trigmin)) ceil(max(trigmax))])

%% PLOT CUMULATIVE NUMBER OF FAMILY MEMBERS (LINEAR)
% ax2 = axes('Position',[.78 .1 .18 .85]); % Axes handle for occurence plot
% roof = ceil(max(F.numel)/10)*10;
% norm = F.numel/roof;
% for n = 1:nf                           % 1:number of families
%    rectangle('Position',[1-norm(n),bm+(h+gap)*(n-1),norm(n),h],...
%              'FaceColor',[0 0 0]);    
% end
% 
% spacing = 10; % You will have to change this manually
% n_spaces = floor(roof/spacing);
% for n = 1:n_spaces
%    xlab{n} = num2str(roof+(1-n)*spacing);
%    xpos(n) = (spacing*(n-1)/roof);
% end
% 
% set(ax2,'YTick',ypos)
% set(ax2,'YTickLabel',[])
% set(ax2,'XGrid','on')
% xlabel('')
% set(ax2,'XTick',xpos)
% set(ax2,'XTickLabel',xlab)
% ax3 = [ax,ax2];
% linkaxes(ax3,'y')

%% PLOT CUMULATIVE NUMBER OF FAMILY MEMBERS (LOGARITHMIC)
% ax2 = axes('Position',[.78 .1 .18 .85]); % Axes handle for occurence plot
% lnw = log10(F.numel);
% roof = ceil(max(lnw));
% norm = lnw/roof;
%  
% for n = 1:nf                           % 1:number of families
%    rectangle('Position',[1-norm(n),bm+(h+gap)*(n-1),norm(n),h],...
%              'FaceColor',[.5 .5 .5]); %F.color(n,:));    
% end
% 
% for n = 1:roof
%    xlab{n} = (['10^',num2str(roof+1-n)]);
%    xpos(n) = ((n-1)/roof);
% end
% 
% set(ax2,'YTick',ypos)
% set(ax2,'YTickLabel',[])
% set(ax2,'XGrid','on')
% xlabel('EVENT COUNT')
% set(ax2,'XTick',xpos)
% set(ax2,'XTickLabel',xlab)
% ax3 = [ax,ax2];
% linkaxes(ax3,'y')

clear ylab ypos xlab xpos x tm t_start t_end gap nf n m h fh dur bm ax
