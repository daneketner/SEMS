function new_wave = hel_menu_addscn(t1,t2)
%
%HEL_MENU_ADDSCN:        
%
%INPUTS: t1 and t2 (start/stop time of new waveform)
%
%OUTPUTS: new_wave (new waveform)

M.fh = figure('MenuBar','none','Name','Add SCN','NumberTitle','off','Position',[600,600,280,190]);
%set(M.fh,'CloseRequestFcn',{@returnEvent,M}) 
M.new_wave = [];
M.t1 = t1; M.t2 = t2;

persistent sta cha net port host
if isempty(sta), sta = 'RDWB'; end, M.sta = sta; 
if isempty(cha), cha = 'BHZ'; end, M.cha = cha; 
if isempty(net), net = 'AV'; end, M.net = net; 
if isempty(port), port = '16022'; end, M.port = port; 
if isempty(host), host = 'avovalve01.wr.usgs.gov'; end, M.host = host; 

uicontrol('Style','Text','String','Station','Position',[30,150,70,20]);
uicontrol('Style','Text','String','Channel','Position',[105,150,70,20]);
uicontrol('Style','Text','String','Network','Position',[180,150,70,20]);
uicontrol('Style','Text','String','Port','Position',[30,100,55,20]);
M.sta_edt = uicontrol('Style','Edit','BackgroundColor','w','String',M.sta,'Position',[30,130,70,20]);
M.cha_edt = uicontrol('Style','Edit','BackgroundColor','w','String',M.cha,'Position',[105,130,70,20]);
M.net_edt = uicontrol('Style','Edit','BackgroundColor','w','String',M.net,'Position',[180,130,70,20]);
M.port_edt = uicontrol('Style','Edit','BackgroundColor','w','String',M.port,'Position',[30,80,55,20]);
uicontrol('Style','Text','String','Host','Position',[90,100,160,20]);
M.host_edt = uicontrol('Style','Edit','BackgroundColor','w','String',M.host,'Position',[90,80,160,20]);
M.cancel_pb = uicontrol('Style','PushButton','String','CANCEL','Position',[80,30,60,30]);
M.add_pb = uicontrol('Style','PushButton','String','ADD SCN','Position',[150,30,60,30]);

set(M.sta_edt,'call',{@sta_edt_call,M}); 
set(M.cha_edt,'call',{@cha_edt_call,M}); 
set(M.net_edt,'call',{@net_edt_call,M}); 
set(M.port_edt,'call',{@port_edt_call,M}); 
set(M.host_edt,'call',{@host_edt_call,M}); 
set(M.cancel_pb,'call',{@cancel_pb_call,M}); 
set(M.add_pb,'call',{@add_pb_call,M}); 

uiwait(M.fh)
sta = M.sta; cha = M.cha; net = M.net; port = M.port; host = M.host; 
new_wave = M.new_wave;
%try delete(M.fh); catch end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function sta_edt_call(varargin)
M = varargin{3};
sta_str = get(M.sta_edt,'String');
if isempty(sta_str)
   errordlg('You must enter a station.','Bad Input','modal')
   set(sta_edt, 'String', M.sta)
else
   M.sta = sta_str;
end

function cha_edt_call(varargin)
M = varargin{3};
cha_str = get(M.cha_edt,'String');
if isempty(cha_str)
   errordlg('You must enter a channel.','Bad Input','modal')
   set(cha_edt, 'String', M.cha)
else
   M.cha = cha_str;
end

function net_edt_call(varargin)
M = varargin{3};
net_str = get(M.net_edt,'String');
if isempty(net_str)
   errordlg('You must enter a network.','Bad Input','modal')
   set(net_edt, 'String', M.net)
else
   M.net = net_str;
end

function port_edt_call(varargin)
M = varargin{3};
port_str = get(M.port_edt,'String');
if isempty(port_str) || isnan(str2double(port_str))
   errordlg('You must enter a number for port.','Bad Input','modal')
   set(port_edt, 'String', M.port)
else
   M.port = port_str;
end

function host_edt_call(varargin)
M = varargin{3};
host_str = get(M.host_edt,'String');
if isempty(host_str)
   errordlg('You must enter a host address.','Bad Input','modal')
   set(host_edt, 'String', M.host)
else
   M.host = host_str;
end

function cancel_pb_call(varargin)
M = varargin{3};
uiresume(M.fh)
   
function add_pb_call(varargin)
M = varargin{3};
scnl = scnlobject(M.sta,M.cha,M.net);
ds = datasource('winston',M.host,str2num(M.port));
M.new_wave = waveform(ds,scnl,M.t1,M.t2);
delete(M.fh)




