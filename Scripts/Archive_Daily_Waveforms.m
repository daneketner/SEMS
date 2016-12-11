
%%
dir = 'C:\Work\RED_Daily_Waveforms\REF';
cd(dir)
d1 = datenum([2009 01 01 00 00 00]);
d2 = datenum([2009 6 30 00 00 00]);
wb = waitbar(0);
wfa = [];
for day = d1:d2 % Range to detect
   waitbar((day-d1)/(d2-d1),wb)
   try
      load([dir,'\',datestr(day,29),'-REF.mat'])
      extract_sst(sst,)
      save([dir,'\',datestr(day,29),'-REF.mat'],'w')
      clear w
   catch
   end
end


