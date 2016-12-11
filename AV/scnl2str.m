function str = scnl2str(scnl)

str = [''];
for n = 1:numel(scnl)
   sta = get(scnl(n),'station');
   if iscell(sta), sta = sta{:}; end
   cha = get(scnl(n),'channel');
   if iscell(cha), cha = cha{:}; end
   net = get(scnl(n),'network');
   if iscell(net), net = net{:}; end
   str = [str,' ',sta,':',cha,':',net];
end