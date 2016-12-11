function varargout = sems_config(varargin)

%% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @sems_config_OpeningFcn, ...
                   'gui_OutputFcn',  @sems_config_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT

%% --- Executes just before sems_config is made visible.
function sems_config_OpeningFcn(obj_handle, eventdata, data, varargin)

setappdata(0,'sems_config_fig',data.sems_config_fig)
data.config.name = 'New_Project';
set(data.name_field,'String',data.config.name)
data.config.scnl = scnlobject;
set(data.scnl_field,'String','No SNCL Selected')
data.config.root_dir= [];
set(data.root_dir_field,'String','No Root Directory Selected')
data.config.config_path= [];
set(data.config_path_field,'String','No Config Path Selected')
data.config.log_path = [];
set(data.log_path_field,'String','No Log Path Selected')
data.config.ds = [];
set(data.ds_field,'String','No Data Source Selected')
data.config.start = floor(now-30);
set(data.start_field,'String',datestr(data.config.start))
data.config.end = ceil(now);
set(data.end_field,'String',datestr(data.config.end))
data.config.dur = data.config.end - data.config.start + 1;
data.config.day = (data.config.start : data.config.end)';

%% DEFAULT EVENT DETECTION PARAMETERS
data.config.edp.bp_low = 0.5;
data.config.edp.bp_hi = 10;
data.config.edp.hilb = 0;
data.config.edp.l_sta = 1;
data.config.edp.l_lta = 8;
data.config.edp.th_on = 2.5;
data.config.edp.th_off = 1.8;
data.config.edp.min_sep = 3;
data.config.edp.min_len = 2;
data.config.edp.lta_mod = 'continuous';
data.config.edp.fix = 8;
data.config.edp.pad = [2,0];
set(data.ed_field,'String','Default Event Detection Parameters');

%% DEFAULT EVENT METRIC PARAMETERS
data.config.metric.pa = 1;
data.config.metric.p2p = 1;
data.config.metric.rms = 1;
data.config.metric.rms_win = 4;
data.config.metric.snr = 1;
data.config.metric.sm_win = 5.12;
data.config.metric.sm_nfft = 1024;
data.config.metric.sm_smo = 4;
data.config.metric.sm_tap = .02;
data.config.metric.pf = 1;
data.config.metric.fi = 1;
data.config.metric.fi_lo = [1 2];
data.config.metric.fi_hi = [10 20];
data.config.metric.iet = 1;
data.config.metric.erp = 1;
data.config.metric.erp_win = 60*60;
set(data.em_field,'String','Default Event Metrics');

%% DEFAULT FAMILY DETECTION PARAMETERS
data.config.family.cc = .75;
data.config.family.cc_win = 8;
data.config.family.cc_size = 1000;
data.config.family.min = 2;
set(data.fd_field,'String','Default Family Detection Settings');

%%
data.output = [];
guidata(obj_handle, data);

%% CHANGE ICON TO SEMS ICON
warning('off','MATLAB:HandleGraphics:ObsoletedProperty:JavaFrame');
jframe=get(data.sems_config_fig,'javaframe');
jIcon=javax.swing.ImageIcon('C:\AVO\SEMS\GUIs\sems_icon.gif');
jframe.setFigureIcon(jIcon);

%% UIWAIT makes sems_config wait for user response (see UIRESUME)
%  uiwait(data.sems_config_fig);

%%
function sems_config_fig_CreateFcn(obj_handle, eventdata, data)

%% MENU: FILE>>LOAD
function Menu_File_Callback(obj_handle, eventdata, data)

function Menu_Load_Config_Callback(obj_handle, eventdata, data)
data = guidata(gcf);
tmp_dir = cd;
try
   cd(data.config.root_dir)
catch
end
[filename, pathname] = uigetfile('*.mat','Load Config');
if isnumeric(pathname)
elseif isdir(pathname)
newfilename = fullfile(pathname, filename);
load(newfilename);
end
if exist('config') == 1
data.config = config;
set(data.name_field,'String',data.config.name)
set(data.root_dir_field,'String',data.config.root_dir)
set(data.config_path_field,'String',data.config.config_path)
set(data.log_path_field,'String',data.config.log_path)
set(data.ds_field,'String',['TYPE: ',get(data.config.ds,'type'),...
                         ' SERVER: ',get(data.config.ds,'server'),...
                         ' PORT: ',num2str(get(data.config.ds,'port'))])
set(data.scnl_field,'String',scnl2str(data.config.scnl))
set(data.start_field,'String',datestr(data.config.start))
set(data.end_field,'String',datestr(data.config.end))
data.config.dur = data.config.end - data.config.start + 1;
data.config.day = (data.config.start : data.config.end)';
set(data.ed_field,'String','User-Defined Event Detection Parameters')
set(data.em_field,'String','User-Defined Event Metrics')
set(data.fd_field,'String','User-Defined Family Detection Settings')
end

cd(tmp_dir)
guidata(gcf, data);

%% MENU: FILE>>SAVE
function Menu_Save_Config_Callback(obj_handle, eventdata, data)
data = guidata(gcf);
tmp_dir = cd;
config = data.config;
try
   cd(config.root_dir)
catch
end
defaultname = [config.name,'_config'];
[filename, pathname] = uiputfile('*.mat','Save Config As',defaultname);
if isnumeric(pathname)
elseif isdir(pathname)
newfilename = fullfile(pathname, filename);
save(newfilename, 'config');
end
cd(tmp_dir)

%% PROJECT NAME (data.config.name)
function name_lab_CreateFcn(obj_handle, eventdata, data)

function name_field_CreateFcn(obj_handle, eventdata, data)

function name_push_CreateFcn(obj_handle, eventdata, data)

function name_push_Callback(obj_handle, eventdata, data)
handles=guidata(gcf);
button_state = get(obj_handle,'Value');
if button_state == get(obj_handle,'Max')
	set(data.name_field,'Enable','on');
elseif button_state == get(obj_handle,'Min')
	set(data.name_field,'Enable','off');
   data.config.name = get(data.name_field,'String');
   if ~isempty(data.config.root_dir) && ~isempty(data.config.name)
      data.config.config_path = fullfile(data.config.root_dir,...
                                          [data.config.name,'_config']);
      set(data.config_path_field,'String',data.config.config_path);                                 
      data.config.log_path = fullfile(data.config.root_dir,...
                                          [data.config.name,'_log']); 
      set(data.log_path_field,'String',data.config.log_path);                                 
   end
end
guidata(gcf, data);

%% PROJECT ROOT DIRECTORY (data.config.root_dir)
function root_dir_lab_CreateFcn(obj_handle, eventdata, data)

function root_dir_field_CreateFcn(obj_handle, eventdata, data)

function root_dir_push_CreateFcn(obj_handle, eventdata, data)

function root_dir_push_Callback(obj_handle, eventdata, data)
data=guidata(gcf);
tmp = uigetdir('C:\','Event Detection Root Directory');
if tmp ~= 0
   data.config.root_dir= tmp;
   set(data.root_dir_field,'String',tmp);
   name = data.config.name;
   if ~isempty(data.config.root_dir) && ~isempty(data.config.name)
      data.config.config_path = fullfile(data.config.root_dir,...
                                          [data.config.name,'_config']);
      set(data.config_path_field,'String',data.config.config_path);                                 
      data.config.log_path = fullfile(data.config.root_dir,...
                                          [data.config.name,'_log']); 
      set(data.log_path_field,'String',data.config.log_path);                                 
   end
end
guidata(gcf, data);

%% PROJECT CONFIG PATH (data.config.config_path)
function config_path_field_Callback(obj_handle, eventdata, data)

function config_path_field_CreateFcn(obj_handle, eventdata, data)

function config_path_push_Callback(obj_handle, eventdata, data)
data=guidata(gcf);
button_state = get(obj_handle,'Value');
if button_state == get(obj_handle,'Max')
	set(data.config_path_field,'Enable','on');
elseif button_state == get(obj_handle,'Min')
	set(data.config_path_field,'Enable','off');
   data.config.config_path = get(data.config_path_field,'String');
end
guidata(gcf, data);

%% PROJECT LOG PATH (data.config.log_path)
function log_path_field_Callback(obj_handle, eventdata, data)

function log_path_field_CreateFcn(obj_handle, eventdata, data)

function log_path_push_Callback(obj_handle, eventdata, data)
data=guidata(gcf);
button_state = get(obj_handle,'Value');
if button_state == get(obj_handle,'Max')
	set(data.log_path_field,'Enable','on');
elseif button_state == get(obj_handle,'Min')
	set(data.log_path_field,'Enable','off');
   data.config.log_path = get(data.log_path_field,'String');
end
guidata(gcf, data);

%% DATA SOURCE (data.config.ds)
function ds_lab_CreateFcn(obj_handle, eventdata, data)

function ds_field_CreateFcn(obj_handle, eventdata, data)

function ds_push_CreateFcn(obj_handle, eventdata, data)

function ds_push_Callback(obj_handle, eventdata, data)
data=guidata(gcf);
[ds scnl] = ds_scnl;
data.config.ds = ds;
set(data.ds_field,'String',['TYPE: ',get(ds,'type'),...
                         ' SERVER: ',get(ds,'server'),...
                         ' PORT: ',num2str(get(ds,'port'))])
guidata(gcf, data);

%% SCNL (data.config.scnl)
function scnl_lab_CreateFcn(obj_handle, eventdata, data)

function scnl_field_CreateFcn(obj_handle, eventdata, data)

function scnl_push_CreateFcn(obj_handle, eventdata, data)

function scnl_push_Callback(obj_handle, eventdata, data)
data=guidata(gcf);
[ds scnl] = ds_scnl;
if ~isempty(scnl)
data.config.scnl = scnl;
set(data.scnl_field,'String',scnl2str(scnl))
end
guidata(gcf, data);

%% START TIME (data.config.start)
function start_lab_CreateFcn(obj_handle, eventdata, data)

function start_field_CreateFcn(obj_handle, eventdata, data)

function start_push_CreateFcn(obj_handle, eventdata, data)

function start_push_Callback(obj_handle, eventdata, data)
handles=guidata(gcf);
button_state = get(data.start_push,'Value');
if button_state == get(data.start_push,'Max')
   dv = datevec(data.config.start);
   dvs = num2str(dv(1),'%04.0f');
   for n = 2:6
      dvs = [dvs,' ',num2str(dv(n),'%02.0f')];
   end
   set(data.start_field,'String',dvs)
	set(data.start_field,'Enable','on');
elseif button_state == get(data.start_push,'Min')
	set(data.start_field,'Enable','off');
   dvs = get(data.start_field,'String');
   ind = strfind(dvs,' ');
   try
      dv(1) = str2num(dvs(1:ind(1)));
      for n = 2:5
         dv(n) = str2num(dvs(ind(n-1):ind(n)));
      end
      dv(6) = str2num(dvs(ind(5):end));
      set(data.start_field,'String',datestr(dv))
      data.config.start = datenum(dv);
   catch
      set(data.start_field,'String',datestr(data.start))
   end
   try
      data.config.day = data.config.start:data.config.end;
      data.config.dur = data.config.end-data.config.start+1;
   catch
   end
end
guidata(gcf, data);

%% END TIME (data.config.end)
function end_lab_CreateFcn(obj_handle, eventdata, data)

function end_field_CreateFcn(obj_handle, eventdata, data)

function end_push_CreateFcn(obj_handle, eventdata, data)

function end_push_Callback(obj_handle, eventdata, data)
handles=guidata(gcf);
button_state = get(data.end_push,'Value');
if button_state == get(data.end_push,'Max')
   dv = datevec(data.config.end);
   dvs = num2str(dv(1),'%04.0f');
   for n = 2:6
      dvs = [dvs,' ',num2str(dv(n),'%02.0f')];
   end
   set(data.end_field,'String',dvs)
	set(data.end_field,'Enable','on');
elseif button_state == get(data.end_push,'Min')
	set(data.end_field,'Enable','off');
   dvs = get(data.end_field,'String');
   ind = strfind(dvs,' ');
   try
      dv(1) = str2num(dvs(1:ind(1)));
      for n = 2:5
         dv(n) = str2num(dvs(ind(n-1):ind(n)));
      end
      dv(6) = str2num(dvs(ind(5):end));
      set(data.end_field,'String',datestr(dv))
      data.config.end = datenum(dv);
   catch
      set(data.end_field,'String',datestr(data.end))
   end
   try
      data.config.day = data.config.start:data.config.end;
      data.config.dur = data.config.end-data.config.start+1;
   catch
   end
end
guidata(gcf, data);

%% EVENT DETECTION (data.config.edp)
function ed_lab_CreateFcn(obj_handle, eventdata, data)

function ed_field_CreateFcn(obj_handle, eventdata, data)

function ed_push_CreateFcn(obj_handle, eventdata, data)

function ed_push_Callback(obj_handle, eventdata, data)
data = guidata(gcf);
setappdata(0,'edp',data.config.edp);
h = sta_lta_config;
waitfor(h);
data.config.edp = getappdata(0,'edp');
set(data.ed_field,'String','User-Defined Event Detection Parameters');
guidata(gcf, data);

%% EVENT METRICS (data.config.metric)
function em_lab_CreateFcn(obj_handle, eventdata, data)

function em_field_CreateFcn(obj_handle, eventdata, data)

function em_push_CreateFcn(obj_handle, eventdata, data)

function em_push_Callback(obj_handle, eventdata, data)
handles=guidata(gcf);
setappdata(0,'metric',data.config.metric);
h = metric_config;
waitfor(h);
data.config.metric = getappdata(0,'metric');
set(data.em_field,'String','User-Defined Event Metrics');
guidata(gcf, data);

%% FAMILY DETECTION (data.config.family)
function fd_lab_CreateFcn(obj_handle, eventdata, data)

function fd_field_CreateFcn(obj_handle, eventdata, data)

function fd_push_CreateFcn(obj_handle, eventdata, data)

function fd_push_Callback(obj_handle, eventdata, data)
handles=guidata(gcf);
setappdata(0,'family',data.config.family);
h = family_config;
waitfor(h);
data.config.family = getappdata(0,'family');
set(data.fd_field,'String','User-Defined Family Detection Settings');
guidata(gcf, data);

%% OK/CANCEL PUSH BUTTONs
function ok_but_Callback(obj_handle, eventdata, data)
h = getappdata(0,'sems_config_fig');
data = guidata(h);
setappdata(0,'config',data.config);
uiresume(h)
delete(h)

function can_but_Callback(obj_handle, eventdata, data)
h = getappdata(0,'sems_config_fig');
data = guidata(h);
uiresume(h)
delete(h)

%% Executes when user attempts to close sems_config_fig.
function sems_config_fig_CloseRequestFcn(obj_handle, eventdata, data)
h = getappdata(0,'sems_config_fig');
data = guidata(h);
if isequal(get(h, 'waitstatus'), 'waiting')
   uiresume(h);
else
   delete(h);
end

%% Outputs from this function are returned to the command line.
function varargout = sems_config_OutputFcn(obj_handle, eventdata, data) 
varargout{1} = [];


