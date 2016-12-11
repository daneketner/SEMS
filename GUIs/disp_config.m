function disp_config(config)

c = config;
ce = c.edp;
cm = c.metric;
cf = c.family;

disp(' ')
disp(['CONFIG FILE FOR PROJECT: ',c.name])
disp('-------------------------------------------')
disp(['ROOT DIRECTORY: ',c.root_dir])
disp(['CONFIG PATH:    ',c.config_path])
disp(['LOG PATH:       ',c.log_path])
disp(' ')
disp('DATA SOURCE:')
disp(c.ds)
disp('SCNL:')
disp(c.scnl)
disp(' ')
disp(['DETECTION START TIME: ',datestr(c.start)])
disp(['DETECTION END TIME:   ',datestr(c.end)])
disp(['DETECTION DURATION (DAYS): ',num2str(c.dur)])
disp(' ')

disp('EVENT DETECTION PARAMETERS:')
disp('-------------------------------------------')
disp(['BANDPASS FILTER LOWER CUTOFF: ',num2str(ce.bp_low),' Hz'])
disp(['BANDPASS FILTER UPPER CUTOFF: ',num2str(ce.bp_hi),' Hz'])
disp(['HILBERT TRANSFORM DATA?: ',num2str(ce.hilb)])
disp(['STA WINDOW LENGTH: ',num2str(ce.l_sta),'(s)'])
disp(['LTA WINDOW LENGTH: ',num2str(ce.l_lta),'(s)'])
disp(['STA/LTA THRESHOLD ON:  ',num2str(ce.th_on)])
disp(['STA/LTA THRESHOLD OFF: ',num2str(ce.th_off)])
disp(['MINIMUM EVENT SEPERATION: ',num2str(ce.min_sep),'(s)'])
disp(['MINIMUM EVENT LENGTH: ',num2str(ce.min_len),'(s)'])
disp(['LTA WINDOW MODE: ',ce.lta_mod])
disp(['FIXED EVENT OUTPUT LENGTH: ',num2str(ce.fix),'(s)'])
disp(['FIXED EVENT PADDING BEFORE TRIGGER: ',num2str(ce.pad(1)),'(s)'])
disp(['FIXED EVENT PADDING AFTER TRIGGER:  ',num2str(ce.pad(2)),'(s)'])
disp(' ')

disp('EVENT METRIC CONFIGURATION:')
disp('-------------------------------------------')
disp('THE FOLLOWING METRICS ARE SELECTED:')
if(cm.pa), disp('PEAK AMPLITUDE'), end
if(cm.p2p), disp('PEAK-TO-PEAK AMPLITUDE'), end
if(cm.rms), 
    disp(['RMS AMPLITUDE WITH ',num2str(cm.rms_win),'(s) WINDOW'])
end
if(cm.snr), disp('SIGNAL-TO-NOISE RATIO'), end
disp(' ')
disp('SPECTRAL METRICS COMPUTED WITH THE FOLLOWING PARAMETERS:')
disp(['   ',num2str(cm.sm_nfft),' SAMPLE NFFT COMPUTED OVER ',...
      num2str(cm.sm_win), '(s) WINDOW'])
if(cm.pf), disp('PEAK FREQUENCY'), end
if(cm.fi), disp(['FREQUENCY INDEX - ',...
   'LOWER BAND: ',num2str(cm.fi_lo(1)),' TO ',num2str(cm.fi_lo(2)),' Hz ',...
   'UPPER BAND: ',num2str(cm.fi_hi(1)),' TO ',num2str(cm.fi_hi(2)),' Hz']),...
end
disp(' ')
if(cm.iet), disp('INTER-EVENT TIME'), end
if(cm.erp), disp(['EVENT RATE PER ',num2str(cm.erp_win/3600),' HOUR(s)']), end
disp(' ')
disp('FAMILY DETECTION PARAMETERS:')
disp('-------------------------------------------')
disp(['CROSS-CORRELATION THRESHOLD: ',num2str(cf.cc)])
disp(['CROSS-CORRELATION WINDOW: ',num2str(cf.cc_win),'(s)'])
disp(['CROSS-CORRELATION SIZE: ',num2str(cf.cc_size),' EVENTS'])
disp(['MINIMUM FAMILY SIZE : ',num2str(cf.min),' EVENTS'])