function varargout = family_config(varargin)

%% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @family_config_OpeningFcn, ...
                   'gui_OutputFcn',  @family_config_OutputFcn, ...
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

%% --- Executes just before family_config is made visible.
function family_config_OpeningFcn(hObject, eventdata, handles, varargin)

handles.original_family = getappdata(0,'family');
handles.family = handles.original_family;

set(handles.cc_edt,'String',num2str(handles.family.cc))
set(handles.cc_win_edt,'String',num2str(handles.family.cc_win))
set(handles.cc_size_edt,'String',num2str(handles.family.cc_size))
set(handles.min_edt,'String',num2str(handles.family.min))
handles.output = [];
guidata(hObject, handles);

%% CHANGE ICON TO SEMS ICON
warning('off','MATLAB:HandleGraphics:ObsoletedProperty:JavaFrame');
jframe=get(handles.family_config_fig,'javaframe');
jIcon=javax.swing.ImageIcon('C:\Work\SEMS\GUIs\sems_icon.gif');
jframe.setFigureIcon(jIcon);

%% UIWAIT makes sems_config wait for user response (see UIRESUME)
uiwait(handles.family_config_fig);
 
%% CALLBACKS
function cc_edt_Callback(hObject, eventdata, handles)
handles=guidata(gcf);
num = str2num(get(handles.cc_edt,'String'));
if numel(num)>0
   handles.family.cc = num;
end
guidata(gcf, handles);
function cc_edt_CreateFcn(hObject, eventdata, handles)

function cc_win_edt_Callback(hObject, eventdata, handles)
handles=guidata(gcf);
num = str2num(get(handles.cc_win_edt,'String'));
if numel(num)>0
   handles.family.cc_win = num;
end
guidata(gcf, handles);
function cc_win_edt_CreateFcn(hObject, eventdata, handles)

function cc_size_edt_Callback(hObject, eventdata, handles)
handles=guidata(gcf);
num = str2num(get(handles.cc_size_edt,'String'));
if numel(num)>0
   handles.family.cc_size = num;
end
guidata(gcf, handles);
function cc_size_edt_CreateFcn(hObject, eventdata, handles)

function min_edt_Callback(hObject, eventdata, handles)
handles=guidata(gcf);
num = str2num(get(handles.min_edt,'String'));
if numel(num)>0
   handles.family.min = num;
end
guidata(gcf, handles);
function min_edt_CreateFcn(hObject, eventdata, handles)

%% OK/CANCEL PUSH BUTTONs
function ok_but_Callback(hObject, eventdata, handles)
handles = guidata(gcf);
setappdata(0,'family',handles.family);
close(gcf)

function can_but_Callback(hObject, eventdata, handles)
handles = guidata(gcf);
handles.family = handles.original_family;
guidata(gcf, handles);
close(gcf)

%% Executes when user attempts to close sta_lta_config_fig.
function family_config_fig_CloseRequestFcn(hObject, eventdata, handles)
handles=guidata(gcf);
if isequal(get(handles.family_config_fig, 'waitstatus'), 'waiting')
   uiresume(handles.family_config_fig);
else
   delete(handles.family_config_fig);
end

%% Outputs from this function are returned to the command line.
function varargout = family_config_OutputFcn(hObject, eventdata, handles) 
varargout{1} = [];


