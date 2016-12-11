% Hourly median

med_array = [];
n = 1;
for time = 733774:1/24:734138
   w = get_red_w('ref:ehz',time,time+1/24,1);
   med_array(n,1)=time; 
   try
      med_array(n,2)=median(w);
   catch
      med_array(n,2)=NaN;
   end
   n=n+1;
end

f = fullfile('C:','Documents and Settings','dketner','Desktop',...
      'RED_Events','Hourly','ref-ehz-rms.m');
save(f,'rms_array')
figure, scatter(rms_array(:,1),rms_array(:,2))
dynamicDateTicks