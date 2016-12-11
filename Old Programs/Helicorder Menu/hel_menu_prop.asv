function Hout = hel_menu_prop(H)
%
%HEL_MENU_PROP:         
%
%INPUTS: H - Helicorder structure to be edited
%
%OUTPUTS: H - Edited Helicorder structure

M.Hin = H; % Original H input
if ~isempty(H.wave)
   M.t1 = get(H.wave(1),'start');
   M.t2 = get(H.wave(1),'end');
   start_vec = datevec(M.t1);
   end_vec = datevec(M.t2);
   M.start_str = sprintf('%04.0f %02.0f %02.0f %02.0f %02.0f %02.0f',start_vec(:));
   M.end_str = sprintf(' %04.0f %02.0f %02.0f %02.0f %02.0f %02.0f',end_vec(:));
   for n = 1:numel(H.wave)
      str1 = [get(H.wave(n),'station'),':',...
              get(H.wave(n),'channel'),':',...
              get(H.wave(n),'network'),' - '];
      if isempty(H.e_sst{n})
         str2 = 'No Events';
      else
         str2 = [num2str(size(H.e_sst{n},1)),' Events'];
      end      
      M.scn_str{n} = [str1 str2];
   end
                      
else
   M.start_str = '2000 01 01 00 00 00';
   M.end_str = '2000 01 01 12 00 00';
   M.scn_str = 'No SCN - No Events';
end
M.minutes = H.tra_w_m;
M.fh = figure('MenuBar','none','Name','Helicorder Properties','NumberTitle','off','Position',[600,600,300,340]);
uicontrol('Style','Text','String','Start Time','Position',[30,300,120,20]);
uicontrol('Style','Text','String','End Time','Position',[150,300,120,20]);
M.start_edt = uicontrol('Style','Edit','BackgroundColor','w','String',M.start_str,'Position',[30,280,120,20]);
M.end_edt = uicontrol('Style','Edit','BackgroundColor','w','String',M.end_str,'Position',[150,280,120,20]);
uicontrol('Style','Text','String','Minutes of data per line','Position',[70,250,130,20]);
M.minutes_edt = uicontrol('Style','Edit','BackgroundColor','w','String',num2str(M.minutes),'Position',[200,250,30,20]);
uicontrol('Style','Text','String','Station:Channel:Network - Events','Position',[60,220,180,20]);
M.scn_lb = uicontrol('Style','ListBox','String',M.scn_str,'Value',1,'Position',[45 120 210 100]);
M.add_pb = uicontrol('Style','PushButton','String','Add SCN','Position',[45,95,60,20]);
M.del_pb = uicontrol('Style','PushButton','String','Delete SCN','Position',[110,95,70,20]);
M.mod_pb = uicontrol('Style','PushButton','String','Edit Events','Position',[185,95,70,20]);
M.cancel_pb = uicontrol('Style','PushButton','String','CANCEL','Position',[80,30,60,30]);
M.apply_pb = uicontrol('Style','PushButton','String','APPLY','Position',[150,30,60,30]);

set(M.start_edt,'call',{@start_edt_call,M,H}); 
set(M.end_edt,'call',{@end_edt_call,M,H}); 
set(M.minutes_edt,'call',{@minutes_edt_call,M,H}); 
set(M.add_pb,'call',{@add_pb_call,M,H}); 
set(M.del_pb,'call',{@del_pb_call,M,H}); 
set(M.mod_pb,'call',{@mod_pb_call,M,H}); 
set(M.del_pb,'call',{@del_pb_call,M,H}); 
set(M.cancel_pb,'call',{@cancel_pb_call,M,H}); 
set(M.apply_pb,'call',{@apply_pb_call,M,H}); 

uiwait(M.fh)
try delete(M.fh); catch end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 

function start_edt_call(varargin) 
M = varargin{3};
start_str = get(M.start_edt,'String');
isGood = goodDateStr(start_str);
if isGood == 0
   errordlg('You must enter time if the form: YYYY MM DD HH MM SS','Bad Input','modal')
   set(M.start_edt,'String',M.start_str);
elseif isGood == 1
   M.start_str = start_str;
   M.t1 = datestr(str2num(M.start_str));
end

function end_edt_call(varargin)
M = varargin{3};
end_str = get(M.end_edt,'String');
isGood = goodDateStr(end_str);
if isGood == 0
   errordlg('You must enter time if the form: YYYY MM DD HH MM SS','Bad Input','modal')
   set(M.end_edt,'String',M.end_str)
elseif isGood == 1;
   M.end_str = end_str;
   M.t2 = datestr(str2num(M.end_str));
end

function isGood = goodDateStr(dateStr) % Check for proper date entry format
isGood = 0;
if length(dateStr)==19 &&...
   isnumeric(str2double(dateStr(1:4))) &&...
   isnumeric(str2double(dateStr(6:7))) &&...
   isnumeric(str2double(dateStr(9:10))) &&...
   isnumeric(str2double(dateStr(12:13))) &&...
   isnumeric(str2double(dateStr(15:16))) &&...
   isnumeric(str2double(dateStr(18:19))) &&...
   strcmpi(dateStr(5),' ') &&...
   strcmpi(dateStr(8),' ') &&...
   strcmpi(dateStr(11),' ') &&...
   strcmpi(dateStr(14),' ') &&...
   strcmpi(dateStr(17),' ')
   isGood = 1;
end

function minutes_edt_call(varargin)
M = varargin{3};
minutes = str2double(get(M.minutes_edt,'String'));
if isnan(minutes)
   errordlg('You must enter a number (in minutes)','Bad Input','modal')
   set(M.minutes_edt,'String',M.minutes);
else
   M.minutes = minutes;
end

function add_pb_call(varargin)
M = varargin{3};
H = varargin{4};
w = hel_menu_addscn(M.t1,M.t2);
if ~isempty(w)
   for m = 1:numel(w) % Multiple station and channels can be added at once
      w_scn = [get(w(m),'station'),':',get(w(m),'channel'),':',...
         get(w(m),'network'),' - No Events'];
      scn = get(M.scn_lb,'String');
      if strcmp(scn,'No SCN - No Events')
         set(M.scn_lb,'String',w_scn);
      else
         scn{end+1} = w_scn;
         set(M.scn_lb,'String',scn);
      end
      H.wave = [H.wave; w(m)];
      H.n = numel(H.wave);
      H.e_sst{H.n} = [];
   end
end

function del_pb_call(varargin)
M = varargin{3};
H = varargin{4};
k = get(M.scn_lb,'Value');
lb_str = get(M.scn_lb,'String');
if strcmp(lb_str,'No SCN - No Events')
   return
else
   H.wave(k) = [];
   H.n = numel(H.wave);
   H.e_sst = {H.e_sst{1:k-1},H.e_sst{k+1:end}};
   lb_str = {lb_str{1:k-1},lb_str{k+1:end}};
   if numel(lb_str)==0
      lb_str = 'No SCN - No Events';
   end
   set(M.scn_lb,'String',lb_str);
end

function mod_pb_call(varargin)
M = varargin{3};
H = varargin{4};

function cancel_pb_call(varargin)
M = varargin{3};
Hout = M.Hin;
uiresume(M.fh)

function apply_pb_call(varargin)
M = varargin{3};
H = varargin{4};
for m = 1:H.n
   if get(H.wave,'start')
   end
end


   




