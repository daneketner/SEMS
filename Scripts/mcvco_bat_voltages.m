
%% VNSS
bvl = [];
t1 = datenum([2013 4 20 11 45 0]);
t2 = datenum([2013 4 20 11 50 0]);
for n=1:300
inc = (n-1)/2;
w = get_w(ds,scnl,t1-inc,t2-inc);
[bvl(n,1) sst] = decode_mcvco(w,'bvl','sst');
bvl(n,2) = sst(1,1) ;
end

%%
bvl2 = [];
t1 = datenum([2013 4 25 20 10 0]);
t2 = datenum([2013 4 25 20 15 0]);
for n=1:6
inc = (n-1)/2;
w = get_w(ds,scnl,t1-inc,t2-inc);
[bvl2(n,1) sst] = decode_mcvco(w,'bvl','sst');
bvl2(n,2) = sst(1,1) ;
end
%%
figure
plot(bvl(:,2),bvl(:,1))
hold on
plot(bvl2(:,2),bvl2(:,1))
dynamicDateTicks

%% PS4A
bvl = [];
t1 = datenum([2013 6 24 21 46 0]);
t2 = datenum([2013 6 24 21 48 0]);
for n=1:100
   inc = (n-1)/2;
   w = get_w(ds,scnl,t1-inc,t2-inc);
   try
   [v t] = decode_mcvco(w,'bvl','sst');
   catch
      v = NaN;
   end
   if ~isnan(v) && v>5 && v<15
      bvl(n,1) = v;
      bvl(n,2) = t(1,1) ;
   else
      bvl(n,1) = NaN;
      bvl(n,2) = NaN ;
   end
end

%%
figure
scatter(bvl(:,2),bvl(:,1))
dynamicDateTicks

%% PN7A
bvl = [];
t1 = datenum([2012 10 29 1 47 0]);
t2 = datenum([2012 10 29 1 48 10]);
w = get_w(ds,scnl,t1,t2);
v = decode_mcvco(w,'bvl');
