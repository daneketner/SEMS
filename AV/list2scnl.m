function scnl = list2scnl(list)

%LIST2SCNL: Convert SCNL list to SCNL Object, 'list' is a cell array of
%    string values with station, channel, and network seperated by ':'
%    (i.e. list{1} might be 'AUL:EHZ:AV')
%
%USAGE: scnl = list2scnl(list)
%
%INPUTS:  list - SCNL list
%
%OUTPUTS:  scnl - SCNL Object array

for n=1:numel(list)
   C = textscan(list{n}, '%s%s%s', 'delimiter', ':');
   sta = C{1};
   if iscell(sta)
      sta = sta{:};
   end
   cha = C{2};
   if iscell(cha)
      cha = cha{:};
   end
   net = C{3};
   if iscell(net)
      net = net{:};
   end
   scnl(n) = scnlobject(sta,cha,net,'');
end