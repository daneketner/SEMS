function subnet = net2subnet(net)

net = upper(net);
switch net
    case {'AV'}
        subnet = {'Akutan','Aniakchak','Augustine','Dutton','Fourpeaked',...
            'Gareloi','Great Sitkin','Iliamna','Kanaga','Katmai','Korovin',...
            'Little Sitkin','Makushin','Okmok','Pavlof','Peulik','Redoubt',...
            'Regional','Semisopochnoi','Shishaldin','Spurr','Tanaga',...
            'Veniaminof','Westdahl','Wrangell'};
    otherwise
        subnet = {''};
end