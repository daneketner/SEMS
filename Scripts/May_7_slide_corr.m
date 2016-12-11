
% Script for discovering events from May 7th drumbeats using a sliding
% correlation technique. This is made obsolete by function seed_corr.m

corr_vec = slide_corr(w,seed);
corr_w = set(w,'data',corr_vec);
corr_sst = findpeaks(corr_w,0.6,3,3);
corr_sst(:,2) = corr_sst(:,1) + 3/24/60/60;
corr_wfa = sst2wfa(corr_sst);
corr_rms = rms(corr_wfa);
corr_wfa(corr_rms<(mean(corr_rms)-std(corr_rms)))=[];
[C c] = clust_fam(corr_wfa,.8);

corr_w = set(w,'data',corr_vec);
corr_sst = findpeaks(corr_w,0.6,3,3);
corr_wfa = sst2wfa(corr_sst);

seed_corr_00 = set(w_00,'data',seed_corr_00);
seed_corr_06 = set(w_06,'data',seed_corr_06);
seed_corr_12 = set(w_12,'data',seed_corr_12);
seed_corr_18 = set(w_18,'data',seed_corr_18);

sst_00 = findpeaks(seed_corr_00,0.8,3,3);
sst_06 = findpeaks(seed_corr_06,0.8,3,3);
sst_12 = findpeaks(seed_corr_12,0.8,3,3);
sst_18 = findpeaks(seed_corr_18,0.8,3,3);

wfa_00 = sst2wfa(sst_00,w_00);
wfa_06 = sst2wfa(sst_06,w_06);
wfa_12 = sst2wfa(sst_12,w_12);
wfa_18 = sst2wfa(sst_18,w_18);

c08_wfa_05_07 = [wfa_00 wfa_06 wfa_12 wfa_18];