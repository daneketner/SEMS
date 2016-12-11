function scnl = MIsubnet2scnl(subnet)

subnet = upper(subnet);
list = [];
switch subnet
    
    case {'SARIGAN'}
        list = {'SARN:BHZ:MI'};
    case {'PAGAN'}
        list = {'PGBF:BHZ:MI','PGNE:BHZ:MI','PGNK:BHZ:MI','PGNW:BHZ:MI',...
            'PGR2:BHZ:MI','PGSE:BHZ:MI','PGWW:BHZ:MI'};
        
end

scnl = list2scnl(list);