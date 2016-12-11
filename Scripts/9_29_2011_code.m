
%% BUILD EVENT FAMILY STRUCTURES FROM OTHER STATIONS USING SST FROM REF
for n = 1:numel(F.REF)
   sst = wfa2sst(F.REF{n});
   for m = 1:length(F.REF{n})
      
      %F.RSO{n}(1,m) = get_red_w('rso',sst(m,1),sst(m,2),0);
      %F.RDN{n}(1,m) = get_red_w('rdn',sst(m,1),sst(m,2),0);
      %F.RDWB{n}(1,m) = get_red_w('rdwb:bhz',sst(m,1),sst(m,2),0);
      %F.RED{n}(1,m) = get_red_w('red:ehz',sst(m,1),sst(m,2),0);
      F.NCT{n}(1,m) = get_red_w('nct',sst(m,1),sst(m,2),0);
   end
end

%%
sst = wfa2sst(wfa.ref);
for n = 1:4727
      wfa.RSO(n) = get_red_w('rso',sst(n,1),sst(n,2),0);
      wfa.RDN(n) = get_red_w('rdn',sst(n,1),sst(n,2),0);
      wfa.RDWB(n) = get_red_w('rdwb:bhz',sst(n,1),sst(n,2),0);
end

%%
sst = wfa2sst(wfa.ref);
      wfa.ref.ehn = waveform();
      wfa.ref.ehe = waveform();
      wfa.rso = waveform();
      wfa.rdn = waveform();
      wfa.rdwb.bhz = waveform();
      wfa.rdwb.bhn = waveform();
      wfa.rdwb.bhe = waveform();
for n = 1:4727
      wfa.ref.ehn(1,n) = get_red_w('ref:ehn',sst(n,1),sst(n,2),0);
      wfa.ref.ehe(1,n) = get_red_w('ref:ehe',sst(n,1),sst(n,2),0);
      wfa.rso(n) = get_red_w('rso',sst(n,1),sst(n,2),0);
      wfa.rdn(n) = get_red_w('rdn',sst(n,1),sst(n,2),0);
      wfa.rdwb.bhz(n) = get_red_w('rdwb:bhz',sst(n,1),sst(n,2),0);
      wfa.rdwb.bhn(n) = get_red_w('rdwb:bhn',sst(n,1),sst(n,2),0);
      wfa.rdwb.bhe(n) = get_red_w('rdwb:bhe',sst(n,1),sst(n,2),0);
end

%% HEAT SCATTER PLOT OF CORRELATION VALUES TO ONE REFERENCE WAVEFORM -
%% DEFAULT WAVEFORM IS THE ONE WITH THE GREATEST AVERAGE CORRELATION TO ALL
%% OTHER WAVEFORMS IN THE FAMILY
figure
bin = 20;
fam = 4;
color = jet(bin);

%
ax(1) = subplot(2,2,1);
hold on
cc = get(C.REF{fam},'corr');
[val pos] = max(sum(cc));
for n=1:bin
   r = find(cc(pos,:)>=(n-1)/bin & cc(pos,:)<=n/bin);
   scatter(get(F.REF{fam}(r),'start'),max(F.REF{fam}(r)),...
      'MarkerEdgeColor',[0 0 0],'MarkerFaceColor',color(n,:))
end
line([get(F.REF{fam}(pos),'start'),get(F.REF{fam}(pos),'start')],...
     [0,max(get(ax(1),'YLim'))],'color',[0 0 0])
dynamicDateTicks
title(['REF:EHZ - Family ', num2str(fam)])

%
ax(2) = subplot(2,2,2);
hold on
cc = get(C.RDN{fam},'corr');
[val pos] = max(sum(cc));
for n=1:bin
   r = find(cc(pos,:)>=(n-1)/bin & cc(pos,:)<=n/bin);
   scatter(get(F.RDN{fam}(r),'start'),max(F.RDN{fam}(r)),...
      'MarkerEdgeColor',[0 0 0],'MarkerFaceColor',color(n,:))
end
line([get(F.RDN{fam}(pos),'start'),get(F.RDN{fam}(pos),'start')],...
     [0,max(get(ax(2),'YLim'))],'color',[0 0 0])
dynamicDateTicks
title(['RDN:EHZ - Family ', num2str(fam)])

%
ax(3) = subplot(2,2,3);
hold on
cc = get(C.RSO{fam},'corr');
[val pos] = max(sum(cc));
for n=1:bin
   r = find(cc(pos,:)>=(n-1)/bin & cc(pos,:)<=n/bin);
   scatter(get(F.RSO{fam}(r),'start'),max(F.RSO{fam}(r)),...
      'MarkerEdgeColor',[0 0 0],'MarkerFaceColor',color(n,:))
end
line([get(F.RSO{fam}(pos),'start'),get(F.RSO{fam}(pos),'start')],...
     [0,max(get(ax(3),'YLim'))],'color',[0 0 0])
dynamicDateTicks
title(['RSO:EHZ - Family ', num2str(fam)])

%
ax(4) = subplot(2,2,4);
hold on
cc = get(C.RDWB{fam},'corr');
[val pos] = max(sum(cc));
for n=1:bin
   r = find(cc(pos,:)>=(n-1)/bin & cc(pos,:)<=n/bin);
   scatter(get(F.RDWB{fam}(r),'start'),max(F.RDWB{fam}(r)),...
      'MarkerEdgeColor',[0 0 0],'MarkerFaceColor',color(n,:))
end
line([get(F.RDWB{fam}(pos),'start'),get(F.RDWB{fam}(pos),'start')],...
     [0,max(get(ax(4),'YLim'))],'color',[0 0 0])
dynamicDateTicks
title(['RDWB:BHZ - Family ', num2str(fam)])
linkaxes(ax,'x')

%% MAKE VECTOR OF SHIFTED SUPERIMPOSED COPIES OF A SINGLE EVENT
% Get selected waveform (start immediately at P arrival)
w = get_red_w('ref:ehz',[2009 03 22 15 41 25.39],[2009 03 22 15 41 35.39],0);
d = get(w,'data');
s = d;
z = zeros(1,1);
% Loop builds an array of shifted waveforms (sw), each of which is a 
% superposition of the original event with a time-shifted copy of itself. 
% Each successive waveform in the array is shifted by one data point, 
% i.e. sw(50) is the original event added to a copy of itself which is
% shifted by 50 data points. This span of time depends on the sampling rate
% All waveforms in sw are the same length at the original event waveform
for n=1:100
   s = [z;s];
   s = s(1:1001);
   x = s+d;
   sw(n)=w;
   sw(n) = set(sw(n),'data',x);
end
plotm2(sw,'scale',.4,'fill',1)

%% CORRELATE SHIFTED WAVEFORMS AGAINST ALL EVENTS IN THE SWARM
% cc is a correlation matrix with the shifted waveform array on the y-axis
% and all events from the swarm along the x-axis
xx = [];
for n = 1:size(cc,2)
   [v p]=max(cc(:,n));
   xx = [xx; n, p, v];
end
clear n v p

bin = 64;
color = jet(bin);
figure, hold on
for n=1:bin
   r = find(xx(:,3)>=(n-1)/bin & xx(:,3)<=n/bin);
   scatter(get(p1(xx(r,1)),'start'),(xx(r,2)-1)/100,amp(xx(r,1))/100,'MarkerEdgeColor',[0 0 0],'MarkerFaceColor',color(n,:))
   %scatter(xx(r,1),(xx(r,2)-1)/100,amp(xx(r,1))/100,'MarkerEdgeColor',[0 0 0],'MarkerFaceColor',color(n,:))
end
dynamicDateTicks
colorbar
clear bin color n r

%% MAKE VECTOR OF SHIFTED SUPERIMPOSED COPIES OF A SINGLE EVENT FOR A
%% SINGLE SHIFT VALUE AND MULTIPLE SCALE VALUES
% Get selected waveform (start immediately at P arrival)
t_shift = .2; % seconds
w = get_red_w('ref:ehz',[2009 03 22 15 41 25.39],[2009 03 22 15 41 35.39],0);
Fs = get(w,'freq');
ww = p1(2313);
ww = extract(ww,'INDEX',1,get(w,'data_length')-1)
sw = waveform();
d1 = get(w,'data');
z = zeros(t_shift*Fs,1);
d2 = [z;d1];
d2 = d2(1:length(d1));
rng = 4;
bin = 100;
scale = linspace(1/rng,rng,bin);
clear z rng
for n=1:bin
   sw(n) = w;
   sw(n) = set(sw(n),'data',d1+d2*scale(n));
end
c = correlation([ww,sw]);
c = xcorr(c);
plot(c,'corr')
cc=get(c,'corr');
cc=cc(2:end,1);
[val pos] = max(cc);
lag = get(c,'lag');
lag=lag(2:end,1);
off = round(abs(lag(pos))*Fs);
ww = extract(ww,'INDEX',off,off+get(sw(pos),'data_length')-1)
plotm2([ww, sw(pos)],'scale',.2,'fill',1)
disp(['Time shifted by ', num2str(t_shift),...
     ' seconds; Scaled by ', num2str(scale(pos)),...
     ' Max correlation = ', num2str(val)])
  
%% GENERATE MULTIPLE WAVEFORM STACKS FROM ONE MULTIPLET, STACK LENGTH = bin
n=28;           % Family number (Largest to smallest family size)
fam=F_rank(n); % Family number (Ordered by first appearance)
bin = 2;       % Size of waveform stacks
% Plot stacks with original polarity & reversed polarity
plotm2(bin_stack(filtfilt(f_bp_P,[F.NCT{fam}, -F.NCT{fam}]),bin,0),'scale',2,'fill',1)

%% If first arrivals are DOWN
plotm2(bin_stack(filtfilt(f_bp_P,F.NCT{fam}),bin,0),'scale',2,'fill',1)
disp('DOWN')

%% If first arrivals are UP
plotm2(bin_stack(filtfilt(f_bp_P,-F.NCT{fam}),bin,0),'scale',2,'fill',1)
disp('UP')

%% PICK P ARRIVALS ON WAVEFORM STACKS (FIGURE MUST HAVE FOCUS)     
tmp = ginput;
P_arv.NCT(fam) = median(tmp(:,1));

%% RECORD POLARITY
P_pol.NCT(fam) = 0;

%% AUTO FIND P-ARRIVAL FOR ALIGNED TRACES (UNFINISHED)
w = F.RDN{1};
Fs = get(w(1),'freq');
D = double(detrend(w));
S = sum(D,2);
X = sign(diff(D));
Y = sign(D);

figure, plot((1:size(X,1))/Fs,sum(X,2),'color',[0 0 1])
hold on
plot((1:size(X,1)+1)/Fs,sum(Y,2),'color',[0 1 0])
line([0 size(X,1)/Fs],[size(X,2) size(X,2)],'color',[0 0 0])
line([0 size(X,1)/Fs],[-size(X,2) -size(X,2)],'color',[0 0 0])
plot((1:size(X,1)+1)/Fs,S/max(abs(S))*size(X,2),'color',[1 0 0])

%% PLOT RELATIVE STATION LAG TIMES

x = P_arv.REF;
X = P_pol.REF;

figure, hold on

neg = find(P_pol.REF==-1&X~=0);
scatter(neg,P_arv.REF(neg)-x(neg),'MarkerEdgeColor',[0 0 0],'MarkerFaceColor',[1 0 0],'Marker','v')
pos = find(P_pol.REF==1&X~=0);
scatter(pos,P_arv.REF(pos)-x(pos),'MarkerEdgeColor',[0 0 0],'MarkerFaceColor',[1 0 0],'Marker','^')

neg = find(P_pol.RSO==-1&X~=0);
scatter(neg,P_arv.RSO(neg)-x(neg),'MarkerEdgeColor',[0 0 0],'MarkerFaceColor',[0 1 0],'Marker','v')
pos = find(P_pol.RSO==1&X~=0);
scatter(pos,P_arv.RSO(pos)-x(pos),'MarkerEdgeColor',[0 0 0],'MarkerFaceColor',[0 1 0],'Marker','^')

neg = find(P_pol.RDWB==-1&X~=0);
scatter(neg,P_arv.RDWB(neg)-x(neg),'MarkerEdgeColor',[0 0 0],'MarkerFaceColor',[0 0 1],'Marker','v')
pos = find(P_pol.RDWB==1&X~=0);
scatter(pos,P_arv.RDWB(pos)-x(pos),'MarkerEdgeColor',[0 0 0],'MarkerFaceColor',[0 0 1],'Marker','^')

neg = find(P_pol.RDN==-1&X~=0);
scatter(neg,P_arv.RDN(neg)-x(neg),'MarkerEdgeColor',[0 0 0],'MarkerFaceColor',[1 0 1],'Marker','v')
pos = find(P_pol.RDN==1&X~=0);
scatter(pos,P_arv.RDN(pos)-x(pos),'MarkerEdgeColor',[0 0 0],'MarkerFaceColor',[1 0 1],'Marker','^')

neg = find(P_pol.NCT==-1&X~=0);
scatter(neg,P_arv.NCT(neg)-x(neg),'MarkerEdgeColor',[0 0 0],'MarkerFaceColor',[1 1 0],'Marker','v')
pos = find(P_pol.NCT==1&X~=0);
scatter(pos,P_arv.NCT(pos)-x(pos),'MarkerEdgeColor',[0 0 0],'MarkerFaceColor',[1 1 0],'Marker','^')

%% PLOT SIMILARITY MATRIX

ARV=[P_arv.REF; P_arv.RSO; P_arv.RDWB; P_arv.RDN];
POL=[P_pol.REF; P_pol.RSO; P_pol.RDWB; P_pol.RDN];
%N = find(POL(1,:)~=0 & POL(2,:)~=0 & POL(3,:)~=0 & POL(4,:)~=0);
N = 1:28;

clear S
for n=N
   for m=N
      S(n,m)=sqrt( (X(1,n)-X(1,m))^2 + (X(2,n)-X(2,m))^2 + (X(3,n)-X(3,m))^2 + (X(4,n)-X(4,m))^2);
   end
end

figure

M = max(max(S));
imagesc(M-S);




