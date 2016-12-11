function plot_ev_fi_rms(e_wfa)

x=get(e_wfa,'start');
y = freq_index(e_wfa,[1 2],[10 20],'plot');
z = event_rms(e_wfa,'val');

figure

scatter(x,y,z/max(z)*20)
dynamicDateTicks