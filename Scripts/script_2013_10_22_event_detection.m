%% GET LAST DAY'S WORTH OF DATA
w = get_w(ds,scnl,now-1+8/24,now+8/24);
%% Currently picking out impulsive events from strange swarm at VNWF on
%  10/22/2013. Instead of using STA/LTA, currently experimenting with
%  finding local peaks from data that has been 'smeared' by 2 seconds, 
%  (signal convolved with 2 second square wave)

d = get(w,'data');
tv = get(w,'timevector');
f = get(w,'freq');
d = d-mean(d);
abd = abs(d);
D = abd;
for n=1:200
    zs = zeros(n,1);
    D = D + [abd(n+1 : end); zs];
end
D = fastsmooth(D,50,1,1);
P = findpeaks(D,2*median(D),10*f);
plot(tv,d)
hold on
plot(tv,D/50,'k')
scatter(tv(P),zeros(numel(P),1),'r')
dynamicDateTicks