% REF HOURLY
rms_array = [];
med_array = [];
pf_array = [];
n = 1;
for time = 733774:1/24:733775%733986
   w = get_red_w('ref:ehz',time,time+1/24,1);
   w = detrend(w);
   if ~isempty(w)
      sub_n_sst = extract_sst(n_sst,time,time+1/24);
      w = set2val(w,sub_n_sst,NaN);
      rms_array(n,1)=time;
      rms_array(n,2)=rms(w);
      med_array(n,1)=time;
      med_array(n,2)=median(abs(w));
      pf_array(n,1)=time;
      pf_array(n,2)=peak_freq(w,'val');
      n=n+1;
   end
end

f = fullfile('C:','Documents and Settings','dketner','Desktop',...
      'RED_Events','Hourly');
save(fullfile(f,'ref_ehz_rms.mat'),'rms_array')
save(fullfile(f,'ref_ehz_med.mat'),'med_array')
save(fullfile(f,'ref_ehz_pf.mat'),'pf_array')