
%% BB Outage Script
t1 = datenum([2012 1 1 0 0 0]);
t2 = round(floor(now*24)/24);
bbt = t1:1/24:t2;
%outage = nan(numel(bb_scnl),numel(bbt));
%host = 'avowinston01.wr.usgs.gov';
host = 'pubavo1.wr.usgs.gov';
port = 16023;
ds = datasource('winston',host,port);
for n = 873:numel(bbt)
   for m = 1:numel(bb_scnl)
      s = bb_scnl{m};
      k = strfind(s, ':');
      sta = s(1:k-1);
      cha = s(k+1:end);
      scnl = scnlobject(sta,cha,'AV');
      w = get_w(ds,scnl,bbt(n),bbt(n+1));
      if isempty(w)
         outage(m,n) = 0;
      else
         w = zero2nan(w,5);
         d = get(w,'data');
         outage(m,n) = single((numel(d)-sum(isnan(d)))/(60*60*50));
      end
      if rem(m,51)==0
         pause(30)
      end
   end
   cd('C:\Work\Station_Outage');
   save('BB_Outage_Array.mat','outage')
end

%% Plot BB Outage
N = 1:numel(bb_scnl);
figure, imagesc(bbt,N,outage)
set(gca,'yTick',2:3:numel(bb_scnl))
set(gca,'yTickLabel',bb_scnl(2:3:end))
dynamicDateTicks

%% BB Outage Script
t1 = datenum([2012 1 1 0 0 0]);
t2 = datenum([2012 12 31 23 0 0]);
bbt = t1:1/24:t2;
outage = nan(numel(bb_scnl_z),numel(bbt));
host{1} = 'pubavo1.wr.usgs.gov';
host{2} = 'avowinston01.wr.usgs.gov';
host{3} = 'avovalve01.wr.usgs.gov';
port = 16022;
ds(1) = datasource('winston',host{1},port);
ds(2) = datasource('winston',host{2},port);
ds(3) = datasource('winston',host{3},port);
for n = 7437:8500%numel(bbt)
   for m = 1:numel(bb_scnl_z)
      s = bb_scnl_z{m};
      k = strfind(s, ':');
      sta = s(1:k-1);
      cha = s(k+1:end);
      scnl = scnlobject(sta,cha,'AV');
      w = get_w(ds,scnl,bbt(n),bbt(n+1));
      if isempty(w)
         if isnan(outage_z(m,n))
            outage_z(m,n) = 0;
         end
      else
         w = zero2nan(w,5);
         d = get(w,'data');
         N = single((numel(d)-sum(isnan(d)))/(60*60*50));
         if N > outage_z(m,n)
            outage_z(m,n) = N;
         end
      end
   end
   cd('C:\Work\Station_Outage');
   save('BB_Outage_Array_Z.mat','outage_z')
   pause(5)
end

%% Plot BB Outage
N = 1:numel(bb_scnl_z);
figure, imagesc(bbt,N,outage_z)
set(gca,'yTick',1:numel(bb_scnl_z))
set(gca,'yTickLabel',bb_scnl_z)
%[v r] = min(find(isnan(outage_z(1,:))));
colorbar
dynamicDateTicks
%xlim([bbt(1) bbt(v)])

%% FILL IN GAPS THAT MIGHT HAVE RESULTED FROM FAILED WAVEFORM SERVER FETCH
for n = 20:size(outage_z,1)
   for m = 2:size(outage_z,2)
      if outage_z(n,m)<.05 && outage_z(n,m-1)>.95
         s = bb_scnl_z{n};
         k = strfind(s, ':');
         sta = s(1:k-1);
         cha = s(k+1:end);
         scnl = scnlobject(sta,cha,'AV');
         w = get_w(ds,scnl,bbt(m),bbt(m+1));clc
         disp(['N = ',num2str(n),' M = ',num2str(m)])
         if isempty(w)
            outage_z(n,m) = 0;
         else
            w = zero2nan(w,5);
            d = get(w,'data');
            outage_z(n,m) = single((numel(d)-sum(isnan(d)))/(60*60*50));
         end
      end
   end
   
end