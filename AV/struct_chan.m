function varargout = struct_chan(server,port,varargin)

WWS = gov.usgs.winston.server.WWSClient(server, port);
connect(WWS);
chan = char(toString(getChannels(WWS)));
chan(1) = []; chan(end) = []; 
gap1 = findstr(chan,'$');
chan(gap1) = ' ';
gap2 = findstr(chan,',');
chan(gap2) = [];
C = textscan(chan, '%s %s %s');
for n = 4:length(C{1,1})
   network = C{1,3}{n};
   station = C{1,1}{n};
   channel = C{1,2}{n};
   str = ['S.',network,'.',station,'.',channel,'=1'];
   eval(str);
end
if nargin > 2
   for n = 1:nargin-2
      str = ['varargout{n}=S.',varargin{n};];
      eval(str);
   end
end
clc







