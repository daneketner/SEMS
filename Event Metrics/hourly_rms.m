% Hourly rms

rms_array = [];
n = 1;
for time = 733774:1/24:734138
   w = get_red_w('ref:ehz',time,time+1/24,1);
   rms_array(n,1)=time; 
   try
      rms_array(n,2)=rms(w);
   catch
      rms_array(n,2)=NaN;
   end
   n=n+1;
end

f = fullfile('C:','Documents and Settings','dketner','Desktop',...
      'RED_Events','REF-EHZ-RMS','ref-ehz-rms.m');
save(f,'rms_array')
figure, scatter(rms_array(:,1),rms_array(:,2))
dynamicDateTicks