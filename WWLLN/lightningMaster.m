function lightningMaster

dr = cd;
load('MASTER.mat')
L = lightningReadDaily(dr,L);
R = 'Alaska_Peninsula';
%R = 'Aleutian_Is';
%V = 'Bogoslof';
%V = 'Cleveland';
V = 'Pavlof';
plotLightning(R,V,'Day',dr,L)
plotLightning(R,V,'Week',dr,L)
plotLightning(R,V,'Month',dr,L)
plotLightning(R,V,'Year',dr,L)
plotLightning(R,V,'All',dr,L)
close all
