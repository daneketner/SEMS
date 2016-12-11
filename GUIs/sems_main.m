function varargout = sems_main(varargin)

%% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @sems_main_OpeningFcn, ...
                   'gui_OutputFcn',  @sems_main_OutputFcn, ...
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

%%
function sems_main_OpeningFcn(hObject, eventdata, handles, varargin)

setappdata(0,'config',[])
setappdata(0,'plog',[])
setappdata(0,'sems_main_fig',hObject)

%% CHANGE ICON TO SEMS ICON
warning('off','MATLAB:HandleGraphics:ObsoletedProperty:JavaFrame');
jframe=get(handles.sems_main_fig,'javaframe');
jIcon=javax.swing.ImageIcon('C:\AVO\SEMS\GUIs\sems_icon.gif');
jframe.setFigureIcon(jIcon);

%%
function varargout = sems_main_OutputFcn(hObject, eventdata, handles) 
varargout{1} = [];

%%
function slider1_Callback(hObject, eventdata, handles)

function callback_scrolltext(source,event,hText)
  textString = get(hText,'UserData');
  nLines = numel(textString);
  lineIndex = nLines-round(get(source,'Value'));
  set(hText,'String',textString(lineIndex:nLines));

function slider1_CreateFcn(hObject, eventdata, handles)

function disp_txt_CreateFcn(hObject, eventdata, handles)

function update_scrolltext(newText,hText,hSlider)
  newText = textwrap(hText,newText);
  set(hText,'String',newText,'UserData',newText);
  nRows = numel(newText);
  if (nRows < 2),
    sliderEnable = 'off';
  else
    sliderEnable = 'on';
  end
  nRows = max(nRows-1,1);
  set(hSlider,'Enable',sliderEnable,'Max',nRows,...
      'SliderStep',[1 3]./nRows,'Value',nRows);

%%
%update_scrolltext({'hello'},hText,hSlider);
%update_scrolltext({'hello'; 'there'; 'silly'; 'world'},hText,hSlider);

function file_mnu_Callback(hObject, eventdata, handles)

function new_proj_mnu_Callback(hObject, eventdata, handles)
handles = guidata(gcf);
ch = struct2cell(handles);
for n = 1:numel(ch)
    try
        set(ch{n},'Enable', 'inactive')
    catch
    end
end
tmp = sems_config;
waitfor(getappdata(0,'sems_config_fig'));
handles.config = getappdata(0,'config');
set(handles.config_edt,'String',handles.config.config_path);
set(handles.log_edt,'String',handles.config.log_path);
h = handles.config.dur;
w = numel(handles.config.scnl);
handles.log.wavefetch = nan(h,w);
handles.log.eventcount = nan(h,w);
handles.log.cur_day = 1;
handles.log.cur_scnl = 1;
handles.log.blockcnt = zeros(1,w);
prjlog = handles.log;
save([handles.config.log_path,'.mat'],'prjlog')
for n = 1:numel(ch)
    try
        set(ch{n},'Enable', 'active')
    catch
    end
end
guidata(gcf, handles);

function load_proj_config_mnu_Callback(hObject, eventdata, handles)
handles = guidata(gcf);
[FileName,PathName] = uigetfile('*.mat','Select Project Config File');
load([PathName,FileName])
handles.config = config;
load([handles.config.log_path,'.mat'])
handles.log = prjlog;
set(handles.config_edt,'String',handles.config.config_path);
set(handles.log_edt,'String',handles.config.log_path);
guidata(gcf, handles);

function run_but_Callback(hObject, eventdata, handles)
handles = guidata(gcf);
clc
[config prjlog] = sems_program(handles.config,handles.log);
guidata(gcf, handles);

function stop_but_Callback(hObject, eventdata, handles)

function config_edt_Callback(hObject, eventdata, handles)

function config_edt_CreateFcn(hObject, eventdata, handles)

function log_edt_Callback(hObject, eventdata, handles)

function log_edt_CreateFcn(hObject, eventdata, handles)



% --------------------------------------------------------------------

% hObject    handle to load_proj_log_mnu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
