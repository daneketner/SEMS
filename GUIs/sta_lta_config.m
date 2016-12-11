function varargout = sta_lta_config(varargin)

%% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @sta_lta_config_OpeningFcn, ...
                   'gui_OutputFcn',  @sta_lta_config_OutputFcn, ...
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

%% --- Executes just before sta_lta_config is made visible.
function sta_lta_config_OpeningFcn(hObject, eventdata, handles, varargin)

handles.original_edp = getappdata(0,'edp');
handles.edp = getappdata(0,'edp');
set(handles.bp_low_edt,'String',num2str(handles.edp.bp_low))
set(handles.bp_hi_edt,'String',num2str(handles.edp.bp_hi))
set(handles.hilb_chk,'Value',handles.edp.hilb)
set(handles.l_sta_edt,'String',num2str(handles.edp.l_sta))
set(handles.l_lta_edt,'String',num2str(handles.edp.l_lta))
set(handles.th_on_edt,'String',num2str(handles.edp.th_on))
set(handles.th_off_edt,'String',num2str(handles.edp.th_off))
set(handles.min_sep_edt,'String',num2str(handles.edp.min_sep))
set(handles.min_len_edt,'String',num2str(handles.edp.min_len))
switch(lower(handles.edp.lta_mod))
   case {'cont','continuous'}
      set(handles.lta_mod_pop,'Value',1)
   case {'freeze','frozen'}
      set(handles.lta_mod_pop,'Value',2)
   case {'grow','growing'}
      set(handles.lta_mod_pop,'Value',3)
end
set(handles.fix_edt,'String',num2str(handles.edp.fix))
set(handles.pad_bef_edt,'String',num2str(handles.edp.pad(1)))
set(handles.pad_aft_edt,'String',num2str(handles.edp.pad(2)))
handles.output = [];
guidata(hObject, handles);

%% CHANGE ICON TO SEMS ICON
warning('off','MATLAB:HandleGraphics:ObsoletedProperty:JavaFrame');
jframe=get(handles.sta_lta_config_fig,'javaframe');
jIcon=javax.swing.ImageIcon('C:\Work\SEMS\GUIs\sems_icon.gif');
jframe.setFigureIcon(jIcon);

%% UIWAIT makes sems_config wait for user response (see UIRESUME)
uiwait(handles.sta_lta_config_fig);

%% WAVEFORM INPUTS PANEL
function bp_low_edt_Callback(hObject, eventdata, handles)
handles=guidata(gcf);
num = str2num(get(handles.bp_low_edt,'String'));
if numel(num)>0
   handles.edp.bp_low = num;
end
guidata(gcf, handles);

function bp_low_edt_CreateFcn(hObject, eventdata, handles)

function bp_hi_edt_Callback(hObject, eventdata, handles)
handles=guidata(gcf);
num = str2num(get(handles.bp_hi_edt,'String'));
if numel(num)>0
   handles.edp.bp_hi = num;
end
guidata(gcf, handles);

function bp_hi_edt_CreateFcn(hObject, eventdata, handles)

function hilb_chk_Callback(hObject, eventdata, handles)
handles=guidata(gcf);
handles.edp.hilb = get(handles.hilb_chk,'Value');
guidata(gcf, handles);

%% STA/LTA PARAMETERS PANEL
function l_sta_edt_Callback(hObject, eventdata, handles)
handles=guidata(gcf);
num = str2num(get(handles.l_sta_edt,'String'));
if numel(num)>0
   handles.edp.l_sta = num;
end
guidata(gcf, handles);

function l_sta_edt_CreateFcn(hObject, eventdata, handles)

function l_lta_edt_Callback(hObject, eventdata, handles)
handles=guidata(gcf);
num = str2num(get(handles.l_lta_edt,'String'));
if numel(num)>0
   handles.edp.l_lta = num;
end
guidata(gcf, handles);

function l_lta_edt_CreateFcn(hObject, eventdata, handles)

function th_on_edt_Callback(hObject, eventdata, handles)
handles=guidata(gcf);
num = str2num(get(handles.th_on_edt,'String'));
if numel(num)>0
   handles.edp.th_on = num;
end
guidata(gcf, handles);

function th_on_edt_CreateFcn(hObject, eventdata, handles)

function th_off_edt_Callback(hObject, eventdata, handles)
handles=guidata(gcf);
num = str2num(get(handles.th_off_edt,'String'));
if numel(num)>0
   handles.edp.th_off = num;
end
guidata(gcf, handles);

function th_off_edt_CreateFcn(hObject, eventdata, handles)

function min_sep_edt_Callback(hObject, eventdata, handles)
handles=guidata(gcf);
num = str2num(get(handles.min_sep_edt,'String'));
if numel(num)>0
   handles.edp.min_sep = num;
end
guidata(gcf, handles);

function min_sep_edt_CreateFcn(hObject, eventdata, handles)

function min_len_edt_Callback(hObject, eventdata, handles)
handles=guidata(gcf);
num = str2num(get(handles.min_len_edt,'String'));
if numel(num)>0
   handles.edp.min_len = num;
end
guidata(gcf, handles);

function min_len_edt_CreateFcn(hObject, eventdata, handles)

function lta_mod_pop_CreateFcn(hObject, eventdata, handles)

function lta_mod_pop_Callback(hObject, eventdata, handles)
handles=guidata(gcf);
val = get(handles.lta_mod_pop,'Value');
if val == 1
   handles.edp.lta_mod = 'continuous';
elseif val == 2
   handles.edp.lta_mod = 'frozen';
elseif val == 3
   handles.edp.lta_mod = 'growing';   
end
guidata(gcf, handles);

%% EVENT OUTPUT PANEL
function fix_edt_Callback(hObject, eventdata, handles)
handles=guidata(gcf);
num = str2num(get(handles.fix_edt,'String'));
if numel(num)>0
   handles.edp.fix = num;
end
guidata(gcf, handles);

function fix_edt_CreateFcn(hObject, eventdata, handles)

function pad_bef_edt_Callback(hObject, eventdata, handles)
handles=guidata(gcf);
num = str2num(get(handles.pad_bef_edt,'String'));
if numel(num)>0
   handles.edp.pad(1) = num;
end
guidata(gcf, handles);

function pad_bef_edt_CreateFcn(hObject, eventdata, handles)

function pad_aft_edt_Callback(hObject, eventdata, handles)
handles=guidata(gcf);
num = str2num(get(handles.pad_aft_edt,'String'));
if numel(num)>0
   handles.edp.pad(2) = num;
end
guidata(gcf, handles);

function pad_aft_edt_CreateFcn(hObject, eventdata, handles)

%% OK/CANCEL PUSH BUTTONs
function ok_but_Callback(hObject, eventdata, handles)
handles = guidata(gcf);
setappdata(0,'edp',handles.edp);
close(gcf)

function can_but_Callback(hObject, eventdata, handles)
handles = guidata(gcf);
handles.edp = handles.original_edp;
guidata(gcf, handles);
close(gcf)

%% Executes when user attempts to close sta_lta_config_fig.
function sta_lta_config_fig_CloseRequestFcn(hObject, eventdata, handles)
handles=guidata(gcf);
if isequal(get(handles.sta_lta_config_fig, 'waitstatus'), 'waiting')
   uiresume(handles.sta_lta_config_fig);
else
   delete(handles.sta_lta_config_fig);
end

%% Outputs from this function are returned to the command line.
function varargout = sta_lta_config_OutputFcn(hObject, eventdata, handles) 
varargout{1} = [];
