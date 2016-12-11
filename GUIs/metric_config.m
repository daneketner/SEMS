function varargout = metric_config(varargin)

%% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @metric_config_OpeningFcn, ...
                   'gui_OutputFcn',  @metric_config_OutputFcn, ...
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

%% --- Executes just before metric_config is made visible.
function metric_config_OpeningFcn(hObject, eventdata, handles, varargin)

handles.original_metric = getappdata(0,'metric');
handles.metric = handles.original_metric;

% AMPLITUDE METRICS PANE
set(handles.pa_chk,'Value',handles.metric.pa)
set(handles.p2p_chk,'Value',handles.metric.p2p)
set(handles.rms_chk,'Value',handles.metric.rms)
set(handles.rms_win_edt,'String',num2str(handles.metric.rms_win))
if handles.metric.rms == 0
   set(handles.rms_win_edt,'Enable','off');  
elseif handles.metric.rms == 1
   set(handles.rms_win_edt,'Enable','on'); 
end
set(handles.snr_chk,'Value',handles.metric.snr)

% SPECTRAL METRICS PANE
set(handles.sm_win_edt,'String',num2str(handles.metric.sm_win))
set(handles.sm_nfft_edt,'String',num2str(handles.metric.sm_nfft))
set(handles.sm_smo_edt,'String',num2str(handles.metric.sm_smo))
set(handles.sm_tap_edt,'String',num2str(handles.metric.sm_tap))
set(handles.pf_chk,'Value',handles.metric.pf)
set(handles.fi_chk,'Value',handles.metric.fi)
set(handles.fi_lo_1_edt,'String',num2str(handles.metric.fi_lo(1)))
set(handles.fi_lo_2_edt,'String',num2str(handles.metric.fi_lo(2)))
set(handles.fi_hi_1_edt,'String',num2str(handles.metric.fi_hi(1)))
set(handles.fi_hi_2_edt,'String',num2str(handles.metric.fi_hi(2)))
if handles.metric.fi == 0
   set(handles.fi_lo_1_edt,'Enable','off');
   set(handles.fi_lo_2_edt,'Enable','off');   
   set(handles.fi_hi_1_edt,'Enable','off');
   set(handles.fi_hi_2_edt,'Enable','off');      
elseif handles.metric.fi == 1
   set(handles.fi_lo_1_edt,'Enable','on');
   set(handles.fi_lo_2_edt,'Enable','on');   
   set(handles.fi_hi_1_edt,'Enable','on');
   set(handles.fi_hi_2_edt,'Enable','on');    
end

% TEMPORAL METRICS PANE
set(handles.iet_chk,'Value',handles.metric.iet)
set(handles.erp_chk,'Value',handles.metric.erp)
t = handles.metric.erp_win;

if t<=60 % SECONDS
   set(handles.erp_edt,'String',num2str(t))
   set(handles.erp_pop,'Value',1)
elseif t>60 && t<=60*60 %MINUTES
   set(handles.erp_edt,'String',num2str(t/60))
   set(handles.erp_pop,'Value',2)
elseif t>60*60 && t<60*60*24 % HOURS
   set(handles.erp_edt,'String',num2str(t/60/60))
   set(handles.erp_pop,'Value',3)
elseif t>60*60*24 % DAYS
   set(handles.erp_edt,'String',num2str(t/60/60/24))
   set(handles.erp_pop,'Value',4)
end

if handles.metric.erp == 0
   set(handles.erp_edt,'Enable','off');
   set(handles.erp_pop,'Enable','off');   
elseif handles.metric.erp == 1
   set(handles.erp_edt,'Enable','on');
   set(handles.erp_pop,'Enable','on');   
end
handles.output = hObject;
guidata(hObject, handles);

%% CHANGE ICON TO SEMS ICON
warning('off','MATLAB:HandleGraphics:ObsoletedProperty:JavaFrame');
jframe=get(handles.metric_config_fig,'javaframe');
jIcon=javax.swing.ImageIcon('C:\Work\SEMS\GUIs\sems_icon.gif');
jframe.setFigureIcon(jIcon);

%% UIWAIT makes sems_config wait for user response (see UIRESUME)
uiwait(handles.metric_config_fig);

%% AMPLITUDE METRICS PANE
function pa_chk_Callback(hObject, eventdata, handles)
handles=guidata(gcf);
handles.metric.pa = get(handles.pa_chk,'Value');
guidata(gcf, handles);

function p2p_chk_Callback(hObject, eventdata, handles)
handles=guidata(gcf);
handles.metric.p2p = get(handles.p2p_chk,'Value');
guidata(gcf, handles);

function rms_chk_Callback(hObject, eventdata, handles)
handles=guidata(gcf);
handles.metric.rms = get(handles.rms_chk,'Value');
if handles.metric.rms == 0
   set(handles.rms_win_edt,'Enable','off');  
elseif handles.metric.rms == 1
   set(handles.rms_win_edt,'Enable','on'); 
end
guidata(gcf, handles);

function rms_win_edt_Callback(hObject, eventdata, handles)
handles=guidata(gcf);
num = str2num(get(handles.rms_win_edt,'String'));
if numel(num)>0
   handles.metric.rms_win = num;
end
guidata(gcf, handles);

function rms_win_edt_CreateFcn(hObject, eventdata, handles)

function snr_chk_Callback(hObject, eventdata, handles)
handles=guidata(gcf);
handles.metric.snr = get(handles.snr_chk,'Value');
guidata(gcf, handles);

%% SPECTRAL METRICS PANE
function sm_win_edt_Callback(hObject, eventdata, handles)
handles=guidata(gcf);
num = str2num(get(handles.sm_win_edt,'String'));
if numel(num)>0
   handles.metric.sm_win = num;
end
guidata(gcf, handles);

function sm_win_edt_CreateFcn(hObject, eventdata, handles)

function sm_nfft_edt_Callback(hObject, eventdata, handles)
handles=guidata(gcf);
num = str2num(get(handles.sm_nfft_edt,'String'));
if numel(num)>0
   handles.metric.sm_nfft = num;
end
guidata(gcf, handles);

function sm_nfft_edt_CreateFcn(hObject, eventdata, handles)

function sm_smo_edt_Callback(hObject, eventdata, handles)
handles=guidata(gcf);
num = str2num(get(handles.sm_smo_edt,'String'));
if numel(num)>0
   handles.metric.sm_smo = num;
end
guidata(gcf, handles);

function sm_smo_edt_CreateFcn(hObject, eventdata, handles)

function sm_tap_edt_Callback(hObject, eventdata, handles)
handles=guidata(gcf);
num = str2num(get(handles.sm_tap_edt,'String'));
if numel(num)>0
   handles.metric.sm_tap = num;
end
guidata(gcf, handles);

function sm_tap_edt_CreateFcn(hObject, eventdata, handles)

function pf_chk_Callback(hObject, eventdata, handles)
handles=guidata(gcf);
handles.metric.pf = get(handles.pf_chk,'Value');
guidata(gcf, handles);

function fi_chk_Callback(hObject, eventdata, handles)
handles=guidata(gcf);
handles.metric.fi = get(handles.fi_chk,'Value');
if handles.metric.fi == 0
   set(handles.fi_lo_1_edt,'Enable','off');
   set(handles.fi_lo_2_edt,'Enable','off');   
   set(handles.fi_hi_1_edt,'Enable','off');
   set(handles.fi_hi_2_edt,'Enable','off');      
elseif handles.metric.fi == 1
   set(handles.fi_lo_1_edt,'Enable','on');
   set(handles.fi_lo_2_edt,'Enable','on');   
   set(handles.fi_hi_1_edt,'Enable','on');
   set(handles.fi_hi_2_edt,'Enable','on');    
end
guidata(gcf, handles);

function fi_lo_1_edt_Callback(hObject, eventdata, handles)
handles=guidata(gcf);
num = str2num(get(handles.fi_lo_1_edt,'String'));
if numel(num)>0
   handles.metric.fi_lo(1) = num;
end
guidata(gcf, handles);

function fi_lo_1_edt_CreateFcn(hObject, eventdata, handles)

function fi_lo_2_edt_Callback(hObject, eventdata, handles)
handles=guidata(gcf);
num = str2num(get(handles.fi_lo_2_edt,'String'));
if numel(num)>0
   handles.metric.fi_lo(2) = num;
end
guidata(gcf, handles);

function fi_lo_2_edt_CreateFcn(hObject, eventdata, handles)

function fi_hi_1_edt_Callback(hObject, eventdata, handles)
handles=guidata(gcf);
num = str2num(get(handles.fi_hi_1_edt,'String'));
if numel(num)>0
   handles.metric.fi_hi(1) = num;
end
guidata(gcf, handles);

function fi_hi_1_edt_CreateFcn(hObject, eventdata, handles)

function fi_hi_2_edt_Callback(hObject, eventdata, handles)
handles=guidata(gcf);
num = str2num(get(handles.fi_hi_2_edt,'String'));
if numel(num)>0
   handles.metric.fi_hi(2) = num;
end
guidata(gcf, handles);

function fi_hi_2_edt_CreateFcn(hObject, eventdata, handles)

%% TEMPORAL METRICS PANE
function iet_chk_Callback(hObject, eventdata, handles)
handles=guidata(gcf);
handles.metric.iet = get(handles.iet_chk,'Value');
guidata(gcf, handles);

function erp_chk_Callback(hObject, eventdata, handles)
handles=guidata(gcf);
handles.metric.erp = get(handles.erp_chk,'Value');
if handles.metric.erp == 0
   set(handles.erp_edt,'Enable','off');
   set(handles.erp_pop,'Enable','off');   
elseif handles.metric.erp == 1
   set(handles.erp_edt,'Enable','on');
   set(handles.erp_pop,'Enable','on');   
end
guidata(gcf, handles);

function erp_edt_Callback(hObject, eventdata, handles)
handles=guidata(gcf);
num = str2num(get(handles.erp_edt,'String'));
mult = get(handles.erp_pop,'Value');
if mult == 1
elseif mult == 2
   mult = 60;
elseif mult == 3
  mult = 60*60;
elseif mult == 4
  mult = 60*60*24;
end
if numel(num)>0
   handles.metric.erp_win = num*mult;
end
guidata(gcf, handles);

function erp_edt_CreateFcn(hObject, eventdata, handles)

function erp_pop_Callback(hObject, eventdata, handles)
handles=guidata(gcf);
num = str2num(get(handles.erp_edt,'String'));
mult = get(handles.erp_pop,'Value');
if mult == 1
elseif mult == 2
   mult = 60;
elseif mult == 3
  mult = 60*60;
elseif mult == 4
  mult = 60*60*24;
end
if numel(num)>0
   handles.metric.erp_win = num*mult;
end
guidata(gcf, handles);

function erp_pop_CreateFcn(hObject, eventdata, handles)

%% OK/CANCEL PUSH BUTTONs
function ok_but_Callback(hObject, eventdata, handles)
handles = guidata(gcf);
setappdata(0,'metric',handles.metric);
close(gcf)

function can_but_Callback(hObject, eventdata, handles)
handles = guidata(gcf);
handles.metric = handles.original_metric;
guidata(gcf, handles);
close(gcf)

%% Executes when user attempts to close sta_lta_config_fig.
function metric_config_fig_CloseRequestFcn(hObject, eventdata, handles)
handles=guidata(gcf);
if isequal(get(handles.metric_config_fig, 'waitstatus'), 'waiting')
   uiresume(handles.metric_config_fig);
else
   delete(handles.metric_config_fig);
end

%% Outputs from this function are returned to the command line.
function varargout = metric_config_OutputFcn(hObject, eventdata, handles) 
varargout{1} = [];







