function varargout = ds_scnl(varargin)

%% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @ds_scnl_OpeningFcn, ...
                   'gui_OutputFcn',  @ds_scnl_OutputFcn, ...
                   'gui_LayoutFcn',  [], ...
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

%%
function ds_scnl_OpeningFcn(hObject, eventdata, handles, varargin)
handles.ds = [];
handles.scnl = scnlobject;
guidata(hObject, handles);
uiwait(handles.ds_scnl_fig);
 
%% Create Functions
function data_source_popupmenu_CreateFcn(hObject, eventdata, handles)

function port_number_edit_CreateFcn(hObject, eventdata, handles)

function network_popupmenu_CreateFcn(hObject, eventdata, handles)

function subnetwork_popupmenu_CreateFcn(hObject, eventdata, handles)

function station_channel_popupmenu_CreateFcn(hObject, eventdata, handles)

function selected_scnl_listbox_CreateFcn(hObject, eventdata, handles)


%% Callback Functions
function data_source_popupmenu_Callback(hObject, eventdata, handles)

function port_number_edit_Callback(hObject, eventdata, handles)

function network_popupmenu_Callback(hObject, eventdata, handles)
handles=guidata(gcf);
netstr = get(hObject,'String');
netval = get(hObject,'Value');
net = netstr{netval};
snl = list_subnets(net);
set(handles.subnetwork_popupmenu,'String',snl);
guidata(gcf, handles);

function subnetwork_popupmenu_Callback(hObject, eventdata, handles)
handles=guidata(gcf);
netstr = get(handles.network_popupmenu,'String');
netval = get(handles.network_popupmenu,'Value');
net = netstr{netval};
sns = get(hObject,'String');
snv = get(hObject,'Value');
subnet = sns{snv};
switch net
    case{'AV'}
        scnl = AVsubnet2scnl(subnet);
    case{'MI'}
        scnl = MIsubnet2scnl(subnet);
end
list = scnl2list(scnl);
set(handles.station_channel_popupmenu,'String',list);
guidata(gcf, handles);

function station_channel_popupmenu_Callback(hObject, eventdata, handles)

function selected_scnl_listbox_Callback(hObject, eventdata, handles)

function add_scnl_button_Callback(hObject, eventdata, handles)  
handles=guidata(gcf);
list = get(handles.selected_scnl_listbox,'String');
sc = get(handles.station_channel_popupmenu,'String');
v = get(handles.station_channel_popupmenu,'Value');
if ischar(list)
    if strcmp(list,'...')
        set(handles.selected_scnl_listbox,'String',{sc{v}});
    end
elseif iscell(list) && strcmp(list{1},'...')
    set(handles.selected_scnl_listbox,'String',{sc{v}});
elseif iscell(list)
    found = 0;
    for n=1:numel(list)
        if strcmp(list{n},sc{v})
            found = 1;
        end
    end
    if found == 0
        newlist = list;
        newlist(end+1) = sc(v);
        set(handles.selected_scnl_listbox,'String',newlist);
    end
end
guidata(gcf, handles);

function remove_scnl_button_Callback(hObject, eventdata, handles)
handles=guidata(gcf);
list = get(handles.selected_scnl_listbox,'String');
v = get(handles.selected_scnl_listbox,'Value');
newlist = list;
newlist(v) = [];
if numel(list)==v && v>1
    set(handles.selected_scnl_listbox,'Value',v-1);
    set(handles.selected_scnl_listbox,'String',newlist);
elseif numel(list)==v && v==1
    set(handles.selected_scnl_listbox,'String',{'...'});
elseif numel(list)>v
    set(handles.selected_scnl_listbox,'String',newlist);
end
guidata(gcf, handles);

function clear_all_button_Callback(hObject, eventdata, handles)
guidata(gcf, handles);
set(handles.selected_scnl_listbox,'String',{'...'});
handles=guidata(gcf);

function return_scnl_Callback(hObject, eventdata, handles)
handles = guidata(gcf);
uiresume(handles.ds_scnl_fig);
host_str = get(handles.data_source_popupmenu,'String');
host_val = get(handles.data_source_popupmenu,'Value');
host = host_str{host_val};
port = get(handles.port_number_edit,'String');
port = str2num(port);
handles.ds = datasource('winston',host,port);
list = get(handles.selected_scnl_listbox,'String');
handles.scnl = list2scnl(list);
guidata(gcf, handles);

function varargout = ds_scnl_OutputFcn(hObject, eventdata, handles)
varargout{1} = handles.ds;
varargout{2} = handles.scnl;
delete(handles.ds_scnl_fig);

function ds_scnl_CloseRequestFcn(hObject, eventdata, handles)
if isequal(get(handles.ds_scnl_fig, 'waitstatus'), 'waiting')
   uiresume(handles.ds_scnl_fig);
else
   delete(handles.ds_scnl_fig);
end






