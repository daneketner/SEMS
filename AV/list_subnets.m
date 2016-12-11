function snl = list_subnets(net)

net = upper(net);
snl = [];
switch net
    case {'AV'}
    snl = {'AKUTAN','ANIAKCHAK','AUGUSTINE','DUTTON','FOURPEAKED','GARELOI',...
           'GREAT SITKIN','ILIAMNA','KANAGA','KATMAI','KOROVIN','LITTLE SITKIN',...
           'MAKUSHIN','OKMOK','PAVLOF','PEULIK','REDOUBT','REGIONAL','SEMISOPOCHNOI'...
           'SHISHALDIN','SPURR','TANAGA','VENIAMINOF','WESTDAHL','WRANGELL'};
    case {'MI'}
        snl = {'PAGAN','SARIGAN'};
end
