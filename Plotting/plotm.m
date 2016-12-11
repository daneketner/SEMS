function plotm(w,varargin)
%
%PLOTM: Plot Multiple Waveforms



E.w = w;
E.cut = zeros(numel(w),1);
lm = .1; rm = .1; tm = .05; bm = .05; % Margins
lw = length(w);

ax_h = (1-tm-bm)/lw;
ax_w = (1-lm-rm);

E.fh = figure();
E.nw = numel(w);

if nargin == 1
   [val pos] = max(get(w,'duration'));
   val = val*24*60*60;
elseif nargin == 2
   val = varargin{1};
end


for n = 1:E.nw
   bot = bm +(n-1)*ax_h;
   E.ax(n) = axes('position',[lm,bot,ax_w,ax_h]);
   plot((get(w(n),'timevector')-get(w(n),'start'))*24*60*60,get(w(n),'data'))
   XLim([0 val])
   set(E.ax(n),'YTick',[])
   text('Position',[.01,.01],'Units','normalized',...
        'HorizontalAlignment','left','VerticalAlignment','bottom',...
        'FontSize',12,'String',[get(w(n),'station'),':',...
        get(w(n),'channel'),':',get(w(n),'network'),':',...
        datestr(get(w(n),'start'))])
end




