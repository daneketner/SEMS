function out_sst = event_editor_temp(wave,varargin)

%EVENT_EDITOR: This GUI is a multi-station/channel event viewer and 
%              modifier. From event_editor, the user can quickly scroll 
%   through an event series seeing both waveforms and spectrograms with the
%   ability to delete, add, or modify events on separate station/channels.
%   This GUI requires a waveform or array of waveforms to display. A set of
%   event start/stop times (cell array w/ same size as input waveforms) can
%   be included, or event_editor can be invoked without an event argument.
%   A multi-station/channel event series can be saved and loaded from
%   event_editor. This GUI can be called from helicorder and return events
%   to helicorder, or generate a new helicorder.
%
%GUI CONTROLS: Up Arrow - Zoom out
%              Down Arrow - Zoom in
%              Left Arrow - Pan left
%              Right Arrow - Pan right
%              Mouse Click (x2) - Add Event (Start/Stop)
%              Ctrl + Mouse Click (x1) - Delete Event
%
%USAGE: event_editor(wave)
%       event_editor(wave,prop_name_1,prop_val_1,...)
%
%VALID NAME/VAL:- 'e_sst',e_sst (Event Start/Stop Times)
%                 'win',win_t (Start Window)
%
%INPUTS: wave  - Reference nx1 waveform object (REQUIRED)  
%        e_sst - Event Start/Stop times (nx2 double), default []
%        win_t - Start Window times (1x2 double), default first minute
% 
%OUTPUTS: out_sst 

%%
if nargin >= 1
   for l = 1:numel(wave)
      if isa(wave(l),'waveform')
         E.wave(l) = wave(l);     
         E.nw = numel(E.wave);
         E.wave_t = [get(E.wave(1),'start') get(E.wave(1),'end')];
         E.Fs(l) = get(E.wave(l),'freq');
         E.e_sst{l} = [];
         E.e_nan(l) = E.wave(l)*NaN;
         E.win_t = [E.wave_t(1) E.wave_t(1)+1/24/60];
         E.sta = get(E.wave,'station');
         E.cha = get(E.wave,'channel');
         E.net = get(E.wave,'network');
         if ~iscell(E.sta)
            E.sta = {E.sta}; E.cha = {E.cha}; E.net = {E.net};
         end
      else
         error(['event_editor:BadArgumentType{ArgIn 1} - ',...
                'Must be a waveform object']);
      end
   end
end

%%
v = varargin;
nv = numel(v);
if ~rem(nv,2) == 0
   error(['event_editor:ArgumentFormat - '...
          'Arguments after wave must appear in pairs'])
end

%%
if nargin > 1
   for p = 1:2:nv-1
      switch v{p}
         case 'e_sst'
            if isa(v{p+1},'double') && (size(v{p+1},2) == 2) && E.nw==1
               E.e_sst{1} = v{p+1};
               E.e_nan = sst2nan(E.e_sst,E.wave);
            elseif iscell(v{p+1}) && numel(v{p+1})==E.nw
               E.e_sst = v{p+1};
               E.e_nan = sst2nan(E.e_sst,E.wave);
            else
               error(['event_editor:BadArgumentType - ''sst'', ',...
                      'Must be cell with size matching wave.'])
            end
         case 'win'
            if isa(v{p+1},'double') && (size(v{p+1},2) == 2)
               E.win_t = v{p+1};
            else
               error(['event_editor:BadArgumentType - ''win'', ',...
                      'Must be 1x2 double.'])
            end
         otherwise
      end
   end
end

%%
E.fh = figure('menubar','none','Name','Event Editor',...
              'Position',[100,100,1200,600]); 
E.ax_n = 2*E.nw;              % Number of Axes (2 per waveform)
E.ax_m = [.05 .03 .03 .03];            % Margins: Left, Right, Bottom, Top
E.ax_h = (1-E.ax_m(3)-E.ax_m(4))/E.ax_n; % Axes height
E.ax_w = 1-E.ax_m(1)-E.ax_m(2);          % Axes height
for m = 1:E.ax_n
   E.ax(m) = axes('position',[E.ax_m(1) E.ax_m(3)+(E.ax_n-m)*E.ax_h,...
                              E.ax_w E.ax_h]); 
end
set(E.fh,'CloseRequestFcn',{@miRET,E})   
set(E.fh,'keypressfcn',{@keyPress,E})
set(E.fh,'UserData',{zeros(1,E.nw),[]}); % {clk_n,clk_t}
E.m.h = uimenu(E.fh,'Label','Edit');
E.m.i(1) = uimenu(E.m.h,'Label','Return Events');
E.m.i(2) = uimenu(E.m.h,'Label','Clear All Events');
set(E.m.i(1),'call',{@miRET,E});
set(E.m.i(2),'call',{@miCLR,E});
E = updatePlot(E);
uiwait(E.fh)
out_sst = E.e_sst;
try delete(E.fh); catch end

%%
function [] = plotAdd(E,w_n)
   n = 2*w_n-1;
   hold(E.ax(n),'on')
   E.win_e_nan(w_n) = extract(E.e_nan(w_n),'time',E.win_t(1),E.win_t(2));
   win_l = get(E.win(w_n),'data_length'); 
   dt = 1/24/60/60/E.Fs(w_n); 
   xT = (dt:dt:dt*win_l)+E.win_t(1)-dt;
   delete(E.ph(w_n,2))
   E.ph(w_n,2) = plot(E.ax(n), xT,get(E.win_e_nan(w_n),'data'),'color',[1 0 0]);
   set(E.ax(:),'HitTest','on','ButtonDownFcn',{@butDown,E})
   set(E.ph(:),'HitTest','on','ButtonDownFcn',{@butDown,E})
end % plotADD

%%
function E = updatePlot(E)
   for q = 1:E.nw
      %%%%% Plot Waveform %%%%
      E.win(q) = extract(E.wave(q),'time',E.win_t(1),E.win_t(2));
      E.win_e_nan(q) = extract(E.e_nan(q),'time',E.win_t(1),E.win_t(2));
      win_l = get(E.win(q),'data_length');
      dt = 1/24/60/60/E.Fs(q);
      xT = (dt:dt:dt*win_l)+E.win_t(1)-dt;
      cla(E.ax(2*q-1)); axes(E.ax(2*q-1));
      E.ph(q,1) = plot(E.ax(2*q-1),xT,get(E.win(q),'data'));
      hold(E.ax(2*q-1),'on')
      try E.ph(q,2) = plot(E.ax(2*q-1), xT,get(E.win_e_nan(q),'data'),...
            'color',[1 0 0]); catch E.ph(q,2) = E.ph(q,1); end
      text('Position',[.01,.01],'Units','normalized',...
           'HorizontalAlignment','left','VerticalAlignment','bottom',...
           'FontSize',12,'String',[E.sta{q},':',E.cha{q},':',E.net{q}])
      %%%%% Make Spectrogram %%%%
      nf_rng = [0 .5];                % Normalized Frequency Range to plot
      F_range = nf_rng*E.Fs(q);       % Frequency range (Hz)
      v = get(E.win(q),'data');       % Window data
      w = E.Fs(q);                    % 1 second bins(time axis)
      n_bins = floor(length(v)/w);    % Number of bins in spectrogram matrix
      fft_array = zeros(w/2, n_bins); % Spectrogram matrix
      for n = 1:floor(length(v)/w)    % Assemble FFT columns into spectrogram
         temp = v(n*w-(w-1):n*w);
         temp = temp - sum(temp)/w;
         fft_temp = fftshift(abs(fft(temp)));
         fft_temp = fft_temp(w/2+1:w);
         fft_array(:,n)= fft_temp;
      end
      warning off
      fft_array = fft_array(1:w/2*nf_rng(2),:); % Remove freqs above F_range
      warning on
      %%%%% Plot Spectrogram %%%%
      cla(E.ax(2*q)); axes(E.ax(2*q));
      E.ph(q,3) = imagesc(xT,F_range,fft_array);
      ylabel('Frequency (Hz)')
      set(E.ax(2*q),'YDir','normal')
      set(E.ax(2*q),'YLim',[min(F_range) max(F_range)])
   end
   linkaxes(E.ax,'x')
   set(E.ax(:),'XTick',[]), dynamicDateTicks(E.ax(end))
   set(E.ax(:),'XLim',[min(xT) max(xT)])
   set(E.ax(:),'HitTest','on','ButtonDownFcn',{@butDown,E})
   set(E.ph(:),'HitTest','on','ButtonDownFcn',{@butDown,E})
   for jj = 1:numel(E.ax), set(E.ax(jj),'Tag',num2str(jj)), end
end % updatPlot

%%
function [] = miRET(varargin)
   uiresume(E.fh)
end % miRET

%%
function [] = miCLR(varargin)
   % Not yet implemented
end % miCLR

%%
function [] = keyPress(varargin)
   E = varargin{3};
   switch varargin{2}.Key;
      case 'rightarrow'
         shft = (E.win_t(2) - E.win_t(1))*.3;
         E.win_t(1) = E.win_t(1)+shft;
         E.win_t(2) = E.win_t(2)+shft;
      case 'leftarrow'
         shft = (E.win_t(2) - E.win_t(1))*.3;
         E.win_t(1) = E.win_t(1)-shft;
         E.win_t(2) = E.win_t(2)-shft;
      case 'uparrow'
         dur = (E.win_t(2) - E.win_t(1))/.7;
         center = E.win_t(1)+(E.win_t(2)-E.win_t(1))/2;
         E.win_t(1) = center - dur/2;
         E.win_t(2) = center + dur/2;
      case 'downarrow'
         dur = (E.win_t(2) - E.win_t(1))*.7;
         center = E.win_t(1)+(E.win_t(2)-E.win_t(1))/2;
         E.win_t(1) = center - dur/2;
         E.win_t(2) = center + dur/2;
   end
   E = winOOB(E);
   updatePlot(E);
end % keyPress

%%
function [] = butDown(varargin)
   clk_obj = varargin{1};
   E = varargin{3};
   switch get(clk_obj,'type')
      case 'axes', clk_ax = clk_obj;
      case 'line', clk_ax = get(clk_obj,'Parent');
      otherwise, clk_ax = E.ax(1); % Is this needed?
   end
   ax_n = str2double(get(clk_ax,'Tag'));
   w_n = ceil(ax_n/2);
   clk_data = get(E.fh,'UserData');
   clk_n = clk_data{1}; % Click counter
   clk_t = clk_data{2}; % Click time

   if strcmp(get(clk_obj,'SelectionType'),'alt') % Ctrl+Clk-->Delete
      mouse = get(clk_ax,'currentpoint');
      clk_t = mouse(1,1);
      deleted = 0; % Has event been deleted?
      k = 1;
      while (deleted == 0) && (k <= size(E.e_sst{w_n},1))
         if clk_t>=E.e_sst{w_n}(k,1) && clk_t<=E.e_sst{w_n}(k,2)
            ce = extract(E.e_nan(w_n),'time',...
               E.e_sst{w_n}(k,1),E.e_sst{w_n}(k,2))*NaN;
            E = mergeNAN(E,w_n,ce);
            E.e_sst{w_n}(k,:) = []; % Click event removed from E.e_sst
            deleted = 1;            % Event has been deleted
            plotAdd(E,w_n);         % Remove event from plot
         end
         k = k+1;
      end
   else % Clk-->Add
      mouse = get(clk_ax,'currentpoint');
      temp = clk_n(w_n);
      clk_n = clk_n*0;
      clk_n(w_n) = temp + 1;
      clk_t(clk_n(w_n)) = mouse(1,1);
      if (clk_n(w_n) == 2)
         if clk_t(1) < clk_t(2)
            t1 = clk_t(1); t2 = clk_t(2);
         elseif clk_t(1) > clk_t(2)
            t1 = clk_t(2); t2 = clk_t(1);
         elseif clk_t(1) == clk_t(2)
            set(E.fh,'UserData',{zeros(1,E.nw),[]});
            return
         end
         E = addSST(E,w_n,t1,t2);
         newEvent = extract(E.wave(w_n),'time',t1,t2);
         E = mergeNAN(E,w_n,newEvent);
         set(E.fh,'UserData',{zeros(1,E.nw),[]});
         plotAdd(E,w_n);
      else
         set(E.fh,'UserData',{clk_n,clk_t});
      end
   end
end % butDown

%%
function E = addSST(E,w_n,t1,t2)
   if isempty(E.e_sst{w_n})
      E.e_sst{w_n} = [t1 t2];
   end
   if E.e_sst{w_n}(1,1)>t2              % First event in E.e_sst{w_n}
      E.e_sst{w_n} = [[t1 t2];E.e_sst{w_n}]; return
   end
   n = 1;
   while n < size(E.e_sst{w_n},1)
      if (E.e_sst{w_n}(n,1) > t1) && (E.e_sst{w_n}(n,1) <= t2)% R overlap
         E.e_sst{w_n}(n,:) = [t1 E.e_sst{w_n}(n,2)]; return
      elseif (E.e_sst{w_n}(n,2) < t1) && (E.e_sst{w_n}(n+1,1) > t2)% No overlap
         temp1 = E.e_sst{w_n}(1:n,:);
         temp2 = E.e_sst{w_n}(n+1:end,:);
         E.e_sst{w_n} = [temp1; [t1 t2]; temp2]; return
      elseif (E.e_sst{w_n}(n,1)<=t1) && (E.e_sst{w_n}(n,2)>t1) && (E.e_sst{w_n}(n,2)<t2)
         E.e_sst{w_n}(n,:) = [E.e_sst{w_n}(n,1) t2]; return
      elseif (E.e_sst{w_n}(n,1)<=t1) && (E.e_sst{w_n}(n,2)>=t2)
         E.e_sst{w_n}(n,:) = [E.e_sst{w_n}(n,1) t2]; return 
      elseif (E.e_sst{w_n}(n,1)>t1) && (E.e_sst{w_n}(n,2)<t2)
         E.e_sst{w_n}(n,:) = [E.e_sst{w_n}(n,1) t2]; return 
      end
      n = n+1;
   end
   if E.e_sst{w_n}(end,2)<t1
      E.e_sst{w_n} = [E.e_sst{w_n};[t1 t2]]; return
   end
end % addSST

%%
function E = mergeNAN(E,w_n,Event)
   dp = 1/24/60/60/E.Fs(w_n);  % Time span between 2 data points
   t1 = get(Event,'start');    % Event start
   t2 = get(Event,'end');      % Event end
   ll = extract(E.e_nan(w_n),'time',E.wave_t(1),t1-dp); % E.e_nan L of Event
   rr = extract(E.e_nan(w_n),'time',t2+dp,E.wave_t(2)); % E.e_nan R of Event
   tmp = [ll; Event; rr];    
   E.e_nan(w_n) = combine(tmp);   % New E.e_nan with Event added
end % mergeNAN

%%
function E = winOOB(E)
   if E.win_t(1) < E.wave_t(1)
      E.win_t(1) = E.wave_t(1); end
   if E.win_t(2) > E.wave_t(2)
      E.win_t(2) = E.wave_t(2); end
end % winOOB
end % event_editor