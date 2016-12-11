x = []; y = []; z = [];
d_start = datenum([2009 03 20 00 00 00]);
d_end = datenum([2009 03 25 00 00 00]);
for day = 733774:733983
f = fullfile('C:','Documents and Settings','dketner','Desktop',...
      'RED_Events','STA_LTA_Daily','REF','SST_002',[datestr(day,29),'.mat']);
e = open(f);   
x = [x; e.sst(:,1)];
y = [y; e.fi];
z = [z; e.rms];
end
z = z/20;
figure,scatter(x,y,z)
hold on

%%
scatter(x,y,z)
hold on
yy=fastsmooth(y,500,3,1);
zz=fastsmooth(z,500,3,1);
zm = max(zz);
top = yy+zz/zm;
bot = yy-zz/zm;
plot(x,top,'color',[1 0 0])
plot(x,bot,'color',[1 0 0])
dynamicDateTicks