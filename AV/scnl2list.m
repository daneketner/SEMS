function list = scnl2list(scnl)

%SCNL2LIST: Convert SCNL object array to list of station:channel pairs
%           (cell array of strings)
%           If scnl contains 3 SCNL Objects (REF:EHZ, RSO:EHZ, RED:EHZ)
%           list{1} will be set to 'REF:EHZ'
%           list{2} will be set to 'RSO:EHZ'
%
%USAGE: list = scnl2list(scnl)
%
%INPUTS:  scnl - SCNL Object

list = {};
for n = 1:numel(scnl)
    sta = get(scnl(n),'station');
    cha = get(scnl(n),'channel');
    net = get(scnl(n),'network');
    list{n} = [sta,':',cha,':',net];
end