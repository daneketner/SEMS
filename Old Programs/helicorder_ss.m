function helicorder(varargin)
%
%HELICORDER: Generates a helicorder with detected events overlay.
%            Allows for interactive manipulation of event times.
%
%USAGE: helicorder()--------------------- Empty helicorder
%       helicorder(wave)----------------- tra_w_m set to 10
%       helicorder(wave,tra_w_m)--------- User-defined trace width
%       helicorder(wave,tra_w_m,events)-- Event overlay
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
%        tra_w_m - an integer value specifying trace width (in minutes)
%        events  - Detected events (WFA form or SST form)
%
%OUTPUTS: User may save events to file

if nargin == 0               % Empty Helicorder
   H.wave = waveform();
elseif (nargin >= 1) && isa(varargin{1},'waveform')
   H.wave = varargin{1};     % Helicorder waveform data
   H.wave = bb_filt(H.wave);
   H.start = get(H.wave, 'start');
   H.end = get(H.wave, 'end');
   H.tv = get(H.wave, 'timevector');
end

if (nargin >= 2) && isnumeric(varargin{2})
   H.tra_w_m = varargin{2};  % Trace Width (Minutes)
end

if nargin == 3
   v = varargin{3};
   if isnumeric(v)&&(size(v,2)==2)
      H.e_sst = v;           % Event Start/Stop Times
   elseif isa(v,'waveform')
      H.e_wfa = v;           % Event WaveForm Array
      H.e_sst = event_wfa2sst(H.e_wfa);
   else
      error(['3rd Argument is neither event start/stop times, ',...
         'nor event waveform objects'])
   end
elseif nargin < 3
   H.e_sst = [];             % Empty Events Array
end

H.fh = figure('Name','Helicorder','menubar',... % Helicorder figure handle
              'none','toolbar','figure');                  
H.ax = axes('position',...                      % Helicorder axes handle
       [.10 .07 .83 .86]);
    
H.m.h = uimenu(H.fh,'Label','File');           % Menu handle
H.m.i(1) = uimenu(H.m.h,'Label','Save Hel');   % Menu Item 1 handle
H.m.i(2) = uimenu(H.m.h,'Label','Load Hel');   % Menu Item 2 handle
set(H.m.i(1),'call',{@miSAVE,H});              % Menu Item 1 callback
set(H.m.i(2),'call',{@miLOAD,H});              % Menu Item 2 callback

if ~isempty(H.wave) 
   H = buildHelicorder(H);
end 

H = add_title(H);

function H = buildHelicorder(H)
cla(H.ax);                       % Clear axes
title(H.ax,'Building Helicorder...','FontSize',12)
w_d = get(H.wave,'data');        % Wave data vector
H.scale = (max(w_d)-min(w_d));   % Scale factor
w_l = get(H.wave,'data_length'); % Wave data length
H.Fs = get(H.wave,'freq');       % Sampling frequency
H.tra_l = H.Fs*60*H.tra_w_m;     % Trace length (data points)
H.tra_n = floor(w_l/H.tra_l);    % Number of helicorder rows (traces)

if ~isempty(H.e_sst)                     % Is the events array non-empty?
   H.e_nan = event_sst2nan(H.e_sst, H.wave); % NaN event form
end

%%%%%%%%%%%%%% Plot helicorder traces alternation blue/black %%%%%%%%%%%%%%

figure(H.fh)
axes(H.ax)
for n = 1:H.tra_n
   H.off(n) = .5+(H.tra_n-n)*.25; % Trace offset from bottom
   H.trace(n) = extract(H.wave,'index',1+(n-1)*H.tra_l,n*H.tra_l)/H.scale +...
              H.off(n);
   H.tra_mean(n) = mean(H.trace(n));        
   if length(H.e_sst)~=0
     H.trace_red(n) = extract(H.e_nan,'index',1+(n-1)*H.tra_l,n*H.tra_l)...
                             /H.scale + H.off(n);
   end
   if rem(n,2)==0  % Plot trace black
      H.trace_h(n) = plot(H.trace(n),'color','k','xunit','minutes');
   else            % Plot trace blue
      H.trace_h(n) = plot(H.trace(n),'color','b','xunit','minutes');
   end
   if n == 1
      hold on
   end
   if length(H.e_sst)~=0 % Plot event red
      H.trace_red_h(n) = plot(H.trace_red(n),'color','r','xunit','minutes');
   end
end

H = add_y_ticks(H);
H = add_title(H);
set(H.ax,'XGrid','on')
xlim([0 H.tra_w_m])
ylim([0 1+(H.tra_n-1)*.25])

set(H.trace_h,'HitTest','on','ButtonDownFcn',{@traClick,H})
if length(H.e_sst)~=0
   set(H.trace_red_h,'HitTest','on','ButtonDownFcn',{@traClick,H})
end

for n = 1:numel(H.trace_h)
   set(H.trace_h(n),'Tag',num2str(n))
   if length(H.e_sst)~=0
      set(H.trace_red_h(n),'Tag',num2str(n))
   end
end

function [] = miSAVE(varargin)
   H = varargin{3};
   saveH = {H.wave H.tra_w_m H.e_sst};
   [year mo da hr mi ss] = datevec(get(H.wave,'start'));
   station = get(H.wave,'station');
   channel = get(H.wave,'channel');
   savdir = ['C:\Documents and Settings\dketner\Desktop\',...
             'My Matlab programs\my_seis\RED_Detected_Events\',...
              num2str(year,'%04d'),'\',num2str(mo,'%02d'),'\',...
              num2str(da,'%02d'),'\',station,'_',channel];
   save(savdir,'saveH'),clc
   
function [] = miLOAD(varargin)
   H = varargin{3};
   cd(['C:\Documents and Settings\dketner\Desktop\My Matlab programs\',...
       'my_seis\RED_Detected_Events\2009'])
   uiopen;
   try
   [H.wave H.tra_w_m H.e_sst]= saveH{:};
   H.wave = bb_filt(H.wave);
   H.start = get(H.wave, 'start');
   H.end = get(H.wave, 'end');
   H.tv = get(H.wave, 'timevector');
   H = buildHelicorder(H);
   catch
   H = oldH;
   end

function traClick(varargin)
   H = varargin{3};                              % Get Helicorder structure
   trace_n = str2double(get(varargin{1}, 'Tag'));% Get Trace number (Tag)
   mouse = get(H.ax,'currentpoint');             % Where is mouse in H.ax?
   ref = (trace_n-1)*H.tra_l+mouse(1,1)*60*H.Fs; % Datapoints from start
   ref_t = H.tv(round(ref));                            % Time of ref
   
   if (H.start > ref_t-30/24/60/60), win_t(1) = H.start;
   else win_t(1) = ref_t-30/24/60/60; end
   if (H.end < ref_t+30/24/60/60),win_t(2) = H.end;
   else win_t(2) = ref_t+30/24/60/60; end
   if ~isempty(H.e_sst)
      H.e_sst = event_editor(H.wave,'sst',H.e_sst,'win',win_t,'hel',H.ax);
   else
      H.e_sst = event_editor(H.wave,'win',win_t,'hel',H.ax);
   end
   H = buildHelicorder(H);

function H = add_title(H)
if isempty(H.wave)
   title(H.ax,'No Data Selected','FontSize',12);
else
   station=get(H.trace(1),'station');    % Station
   channel=get(H.trace(1),'channel');    % Channel
   network=get(H.trace(1),'network');    % Network
   scn_str = [station, ' ', channel, ' ', network];
   dv1 = datevec(get(H.trace(1),'start')); % Date vec (first trace point)
   dv2 = datevec(get(H.trace(end),'end')); % Date vec (last trace point)
   if dv1(1)==dv2(1) && dv1(2)==dv2(2) && dv1(3)==dv2(3) % Same Y,M,D ?
      span = [datestr(dv1,0), ' to ', datestr(dv2,13)]; % Less repetitive
   else % Different Year , Month, or Day
      span = [datestr(dv1), ' to ', datestr(dv2)]; % Full dates displayed
   end

   if length(H.e_sst)~=0 % Are there any events?
      noe = [': ', num2str(length(H.e_sst)), ' events detected, '];
   else
      noe = ', ';
   end
   H.tit = [scn_str, noe, span];
   title(H.ax,H.tit,'FontSize',12);
end

function H = add_y_ticks(H)
   ylabel(H.ax,'')
   n_lab = 0;
   for k = H.tra_n:-1:1
      dv = datevec(get(H.trace(k),'start')); % Date vec (Start of trace n)
      if (round(dv(6))==60 && dv(5)==59) || (round(dv(6))==0 && dv(5)==0)
         n_lab = n_lab + 1;
         tick_pos(n_lab) = H.tra_mean(k);
         tick_lab{n_lab} = datestr(get(H.trace(k),'start'),13);
      end
   end
   set(H.ax,'YTick',tick_pos)
   set(H.ax,'YTickLabel',tick_lab)
   

   
   