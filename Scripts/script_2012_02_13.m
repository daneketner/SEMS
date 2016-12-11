
%% A script

% Author: Dane Ketner, Alaska Volcano Observatory
% $Date$
% $Revision$

w1 = get_red_w('ref:ehz',e1-1.5/24,e1+.5/24,0);

%%
w2 = get_red_w('ref:ehz',e2-1.5/24,e2+.5/24,0);
w3 = get_red_w('ref:ehz',e3-1.5/24,e3+.5/24,0);
w4 = get_red_w('ref:ehz',e4-1.5/24,e4+.5/24,0);
w5 = get_red_w('ref:ehz',e5-1.5/24,e5+.5/24,0);
w6 = get_red_w('ref:ehz',e6-1.5/24,e6+.5/24,0);
w7 = get_red_w('ref:ehz',e7-1.5/24,e7+.5/24,0);

%%
event = v;
c = correlation(event);
set(c,'trig',get(c,'start'));
c = taper(c);
c = butter(c,[1 10]);
c = xcorr(c,[0,6]);
c = sort(c);
c = adjusttrig(c,'MIN');
c = linkage2(c);
c = cluster(c,.7);
stat = getclusterstat(c);
corr = get(c,'corr');
[V I] = max(sum(corr(stat.index{1},stat.index{1})));
seed = event(stat.index{1}(I));
st_seed = event_pick(seed);
st_seed = st_seed{:};
seed = sst2wfa(st_seed,seed);
clear I V corr event st_seed

%%
[tt cc] = seed_corr(seed,get(seed,'start'));