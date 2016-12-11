% Hourly rms RSO
% 733408 --> Jan 1, 2008
% 733856 --> March 24, 2009 (RSO takes a break after this point)

rms_array = [];
n = 1;
for time = 733408:1/24:733856
   w = get_red_w('rso',time,time+1/24,1);
   rms_array(n,1)=time; 
   try
      rms_array(n,2)=rms(w);
   catch
      rms_array(n,2)=NaN;
   end
   n=n+1;
end

f = fullfile('C:','Documents and Settings','dketner','Desktop',...
      'RED_Events','RSO-EHZ-RMS','rso-ehz-rms.m');
save(f,'rms_array')
figure, scatter(rms_array(:,1),rms_array(:,2),3)
dynamicDateTicks