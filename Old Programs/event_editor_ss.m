function out_sst = event_editor(wave,varargin)
%
%EVENT_EDITOR: 
%
%USAGE: event_editor(wave)
%       event_editor(wave,prop_name,prop_val)
%
%VALID NAME/VAL:- 'sst',e_sst (Event Start/Stop Times)
%                 'win',win_t (Start Window)
%                 'hel',H     (Helicorder Handle) 
%
%INPUTS: wave  - Reference 1x1 waveform object (REQUIRED)  
%        e_sst - Event Start/Stop times (nx2 double), default []
%        win_t - Start Window times (1x2 double), default first minute
%        Hax   - Axes handle of calling helicorder, default []
% 
%OUTPUTS: out_sst 

if nargin >= 1
   if isa(wave,'waveform')
      E.wave = wave;
      E.wave_t = [get(E.wave,'start') get(E.wave,'end')];
      E.Fs = get(E.wave,'freq');
      E.e_sst = [];
      E.e_nan = E.wave*NaN;
      E.win_t = [E.wave_t(1) E.wave_t(1)+30/24/60/60];
   end
else
   error(['event_editor:BadArgumentType{ArgIn 1} - ',...
             'Must be a 1x1 waveform']);
end

nva = numel(varargin);
if ~rem(nva,2) == 0
   error(['event_editor:ArgumentFormat - '...
          'Arguments after wave must appear in pairs'])
end

if nargin > 1
   for m = 1:2:nva-1
      switch varargin{m}
         case 'sst'
            if isa(varargin{m+1},'double') && (size(varargin{m+1},2) == 2)
               E.e_sst = varargin{m+1};
               E.e_nan = event_sst2nan(E.wave,E.e_sst);
            else
               error(['event_editor:BadArgumentType - ''sst'', ',...
                      'Must be nx2 double.'])
            end
         case 'win'
            if isa(varargin{m+1},'double') && (size(varargin{m+1},2) == 2)
               E.win_t = varargin{m+1};
            else
               error(['event_editor:BadArgumentType - ''win'', ',...
                      'Must be 1x2 double.'])
            end
         case 'hel'
            E.Hax = varargin{m+1};
         otherwise
      end
   end
end

E.fh = figure('menubar','none','Name','Event Editor',...
              'Position',[400,400,600,600]); 
set(E.fh,'UserData',{'default',0,[]});
E.ax(1) = axes('position',[.07 .50 .89 .45]); 
E.ax(2) = axes('position',[.07 .05 .89 .45]); 
updatePlot(E);
E.m.h = uimenu(E.fh,'Label','Edit');
E.m.i(1) = uimenu(E.m.h,'Label','Add Event');
E.m.i(2) = uimenu(E.m.h,'Label','Delete Event');
E.m.i(3) = uimenu(E.m.h,'Label','Zoom In');
E.m.i(4) = uimenu(E.m.h,'Label','Zoom Out');
E.m.i(5) = uimenu(E.m.h,'Label','Pan Left');
E.m.i(6) = uimenu(E.m.h,'Label','Pan Right');
E.m.i(7) = uimenu(E.m.h,'Label','Return Event','Separator','on');
set(E.m.i(1),'call',{@miADD,E}); 
set(E.m.i(2),'call',{@miDEL,E}); 
set(E.m.i(3),'call',{@miZIN,E});
set(E.m.i(4),'call',{@miZOUT,E}); 
set(E.m.i(5),'call',{@miPANL,E});
set(E.m.i(6),'call',{@miPANR,E});
set(E.m.i(7),'call',{@miRET,E});
uiwait(E.fh)
E
out_sst = E.e_sst;
try delete(E.fh); catch end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [] = updatePlot(E)

%%%%% Plot Waveform %%%%
E.win = extract(E.wave,'time',E.win_t(1),E.win_t(2));
E.win_e_nan = extract(E.e_nan,'time',E.win_t(1),E.win_t(2));
E.win_l = get(E.win,'data_length'); % Data Length (event)
dt = 1/24/60/60/E.Fs; 
E.xT = (dt:dt:dt*E.win_l)+E.win_t(1)-dt;
cla(E.ax(1)); axes(E.ax(1));
E.ph(1) = plot(E.ax(1),E.xT,get(E.win,'data')); hold(E.ax(1), 'on')
try E.ph(2) = plot(E.ax(1),E.xT,get(E.win_e_nan,'data'),'color',[1 0 0]);
catch E.ph(2) = E.ph(1); end   
set(E.ax(1),'XTick',[],'XLim',[min(E.xT) max(E.xT)])

%%%%% Make Spectrogram %%%%
nf_rng = [0 .5];
F_range = nf_rng*E.Fs;
v = get(E.win,'data');
w = E.Fs;                       % 1 second bins(time axis)
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
fft_array = fft_array(1:w/2*nf_rng(2),:); % Remove freqs above max(F_range)
warning on

%%%%% Plot Spectrogram %%%%
cla(E.ax(2)); axes(E.ax(2));
E.ph(3) = imagesc(E.xT,F_range,fft_array);
ylabel('Frequency (Hz)')
set(gca,'YDir','normal') 
linkaxes(E.ax,'x')
dynamicDateTicks(E.ax(2))
xlim(E.ax(2),[min(E.xT) max(E.xT)])
ylim(E.ax(2),[min(F_range) max(F_range)])
set(E.ax(:),'HitTest','on','ButtonDownFcn',{@butDown,E})
set(E.ph(:),'HitTest','on','ButtonDownFcn',{@butDown,E})

end % updatePlot

function [] = miADD(varargin)
   E = varargin{3};
   set(E.fh,'Pointer','fullcross');
   set(E.m.i(:),'Checked','off');
   set(E.m.i(1),'Checked','on');
   set(E.fh,'UserData',{'add',0,[]});
end % miADD

function [] = miDEL(varargin)
   E = varargin{3};
   curs = load_cursor('delete.bmp');
   set(E.fh,'Pointer','custom','PointerShapeCData',curs);
   set(E.m.i(:),'Checked','off');
   set(E.m.i(2),'Checked','on');
   set(E.fh,'UserData',{'del',0,[]});
end % miDEL

function [] = miZIN(varargin)
   E = varargin{3};
   curs = load_cursor('zoomin.bmp');
   set(E.fh,'Pointer','custom','PointerShapeCData',curs);
   set(E.m.i(:),'Checked','off');
   set(E.m.i(3),'Checked','on');
   set(E.fh,'UserData',{'zin',0,[]});
end % miZIN

function [] = miZOUT(varargin)
   E = varargin{3};
   curs = load_cursor('zoomout.bmp');
   set(E.fh,'Pointer','custom','PointerShapeCData',curs);
   set(E.m.i(:),'Checked','off');
   set(E.m.i(4),'Checked','on');
   set(E.fh,'UserData',{'zout',0,[]});
end % miZOUT

function [] = miPANL(varargin)
   E = varargin{3};
   curs = load_cursor('panleft.bmp');
   set(E.fh,'Pointer','custom','PointerShapeCData',curs);
   set(E.m.i(:),'Checked','off');
   set(E.m.i(5),'Checked','on');
   set(E.fh,'UserData',{'panl',0,[]});
end % miPANL

function [] = miPANR(varargin)
   E = varargin{3};
   curs = load_cursor('panright.bmp');
   set(E.fh,'Pointer','custom','PointerShapeCData',curs);
   set(E.m.i(:),'Checked','off');
   set(E.m.i(6),'Checked','on');
   set(E.fh,'UserData',{'panr',0,[]});
end % miPANR

function [] = miRET(varargin)
   uiresume(E.fh)
end % miRET

function [] = butDown(varargin)
   E = varargin{3};
   clk_data = get(E.fh,'UserData');
   mode = clk_data{1};
   clk_n = clk_data{2};
   clk_t = clk_data{3};
   switch mode
      case 'default'
         return
      case 'add'
         mouse = get(E.ax(1),'currentpoint');
         clk_n = clk_n + 1;
         clk_t(clk_n) = mouse(1,1);
         set(E.fh,'UserData',{'add',clk_n,clk_t});
         if clk_n == 2
            E = addSST(E,clk_t(1),clk_t(2));
            newEvent = extract(E.wave,'time',clk_t(1),clk_t(2));
            E = mergeNAN(E, newEvent)
            clk_n = 0; clk_t = [];
            set(E.fh,'UserData',{'add',clk_n,clk_t});
            updatePlot(E);
         end
      case 'del'
         mouse = get(E.ax(1),'currentpoint');
         clk_t = mouse(1,1);
         deleted = 0; % Has event been deleted?
         k = 1;
         while (deleted == 0) && (k < size(E.e_sst,1))
            if clk_t>=E.e_sst(k,1) && clk_t<=E.e_sst(k,2) % Event clicked?
               ce = extract(E.e_nan,'time',E.e_sst(k,1),E.e_sst(k,2))*NaN; 
               E = mergeNAN(E, ce);
               E.e_sst(k,:) = [];      % Click event removed from E.e_sst
               deleted = 1;            % Event has been deleted     
               updatePlot(E);          % Remove event from plot
            end
            k = k+1;
         end
      case 'zin'
         mouse = get(E.ax(1),'currentpoint');
         clk_t = mouse(1,1);
         dur = (E.win_t(2) - E.win_t(1))*.7;
         center = clk_t;
         E.win_t(1) = center - dur/2;
         E.win_t(2) = center + dur/2;
         E = winOOB(E);
         updatePlot(E);
      case 'zout'
         mouse = get(E.ax(1),'currentpoint');
         clk_t = mouse(1,1);
         dur = (E.win_t(2) - E.win_t(1))/.7;
         center = clk_t;
         E.win_t(1) = center - dur/2;
         E.win_t(2) = center + dur/2;
         E = winOOB(E);
         updatePlot(E);
      case 'panl'
         shft = (E.win_t(2) - E.win_t(1))*.3;
         E.win_t(1) = E.win_t(1)-shft;
         E.win_t(2) = E.win_t(2)-shft;
         E = winOOB(E);
         updatePlot(E);
      case 'panr'
         shft = (E.win_t(2) - E.win_t(1))*.3;
         E.win_t(1) = E.win_t(1)+shft;
         E.win_t(2) = E.win_t(2)+shft;
         E = winOOB(E);
         updatePlot(E);
      otherwise
   end
end % butDown

function E = addSST(E,t1,t2)
   if isempty(E.e_sst)
      E.e_sst = [t1 t2];
   end
   if E.e_sst(1,1)>t2              % First event in E.e_sst
      E.e_sst = [[t1 t2];E.e_sst]; return
   end
   n = 1;
   while n < size(E.e_sst,1)
      if (E.e_sst(n,1) > t1) && (E.e_sst(n,1) <= t2)% R overlap
         E.e_sst(n,:) = [t1 E.e_sst(n,2)]; return
      elseif (E.e_sst(n,2) < t1) && (E.e_sst(n+1,1) > t2)% No overlap
         temp1 = E.e_sst(1:n,:);
         temp2 = E.e_sst(n+1:end,:);
         E.e_sst = [temp1; [t1 t2]; temp2]; return
      elseif (E.e_sst(n,1)<=t1) && (E.e_sst(n,2)>t1) && (E.e_sst(n,2)<t2)
         E.e_sst(n,:) = [E.e_sst(n,1) t2]; return
      elseif (E.e_sst(n,1)<=t1) && (E.e_sst(n,2)>=t2)
         E.e_sst(n,:) = [E.e_sst(n,1) t2]; return 
      elseif (E.e_sst(n,1)>t1) && (E.e_sst(n,2)<t2)
         E.e_sst(n,:) = [E.e_sst(n,1) t2]; return 
      end
      n = n+1;
   end
   if E.e_sst(end,2)<t1
      E.e_sst = [E.e_sst;[t1 t2]]; return
   end
end % addSST

function E = mergeNAN(E,Event)
   dp = 1/24/60/60/E.Fs;     % Time span between 2 data points
   t1 = get(Event,'start');  % Event start
   t2 = get(Event,'end');    % Event end
   ll = extract(E.e_nan,'time',E.wave_t(1),t1-dp); % E.e_nan L of Event
   rr = extract(E.e_nan,'time',t2+dp,E.wave_t(2)); % E.e_nan R of Event
   tmp = [ll; Event; rr];    
   E.e_nan = combine(tmp);   % New E.e_nan with Event added
end % mergeNAN
   
function E = winOOB(E)
   if E.win_t(1) < E.wave_t(1)
      E.win_t(1) = E.wave_t(1); end
   if E.win_t(2) > E.wave_t(2)
      E.win_t(2) = E.wave_t(2); end
end % winOOB

end % event_editor
