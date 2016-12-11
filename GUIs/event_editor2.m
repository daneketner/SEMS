function out = event_editor2(w,varargin)
%
%EVENT_EDITOR2

%% E - Event Editor Structure
E.w = w;                   % waveforms
E.nw = numel(w);
% if E.keep(n) = 1, E.w(n) is retained in 'out'
% if E.keep(n) = 0, E.w(n) is deleted
E.keep = ones(E.nw,1); % Default: keep all waveforms in w
if nargin == 1
   N = 20;
elseif nargin == 2
   N = varargin{1};
end
A = floor(E.nw/N);
R = E.nw-A*N;
for k = 1:A
   K = (k-1)*N+1:k*N;
   E.keep(K) = eventeditor2(w(K));
end
if R>0
   E.keep(end-R+1:end) = eventeditor2(w(end-R+1:end));
end
out = E.w(find(E.keep));

%%
function sub_keep = eventeditor2(sub_w)
   nw = numel(sub_w);
   sub_keep = ones(nw,1);
   fh = figure;
   lm = .1; rm = .1; tm = .05; bm = .05; % Margins
   ax_h = (1-tm-bm)/nw;
   ax_w = (1-lm-rm);
   set(fh,'CloseRequestFcn',{@Eclose,fh})
   [val pos] = max(get(w,'duration'));
   val = val*24*60*60;
   for n = 1:nw
      bot = bm +(n-1)*ax_h;
      ax(n) = axes('position',[lm,bot,ax_w,ax_h]);
      plot((get(sub_w(n),'timevector')-get(sub_w(n),'start'))*24*60*60,...
            get(bp_filt(sub_w(n)),'data'))
      XLim([0 val])
      if n ~= 1
         set(ax(n),'XTickLabel',[])
      end
      set(ax(n),'YTick',[])
      text('Position',[.01,.01],'Units','normalized',...
         'HorizontalAlignment','left','VerticalAlignment','bottom',...
         'FontSize',10,'String',[get(sub_w(n),'station'),':',...
         get(sub_w(n),'channel'),':',get(sub_w(n),'network'),':',...
         datestr(get(sub_w(n),'start'))])
      grid on
   end

   for jj = 1:numel(ax), set(ax(jj),'Tag',num2str(jj)), end
   set(ax(:),'HitTest','on','ButtonDownFcn',{@butDown})
   uiwait(fh)
   try delete(fh); catch end

%%
   function []=butDown(varargin)
      h = varargin{1};
      ax_n = str2double(get(h,'Tag'));
      if sub_keep(ax_n)==1
         sub_keep(ax_n)=0;
         set(h,'color',[1 .8 .8])
      elseif sub_keep(ax_n)==0
         sub_keep(ax_n)=1;
         set(h,'color',[1 1 1])
      end
   end % butDown

%%     
   function []=Eclose(varargin)
      uiresume(fh)
   end % Eclose
end % eventeditor2
end % event_editor2

