function binder = clust_binder(F1,F2)

N = numel(F1.T);
binder.count = zeros(N,1);
binder.clustindex  = zeros(N,2);
binder.clustindex(:,1) = 1:N;
binder.eventindex{N,2} = [];
for n = 1:numel(F1.T)
   t1 = F1.T{n};
   for m = 1:numel(F2.T)
      tmp1 = [];
      tmp2 = [];
      t2 = F2.T{m};
      ovr = 0;
      for k = 1:numel(t1)
         for kk = 1:numel(t2)
            if abs(t1(k) - t2(kk)) < 4/24/60/60
               ovr = ovr + 1;
               tmp1(end+1) = F1.I{n}(k);
               tmp2(end+1) = F2.I{m}(kk);
            end
         end
      end
      if ovr > binder.count(n)
         binder.count(n) = ovr;
         binder.clustindex(n,2) = m;
         binder.eventindex{n,1} = tmp1;
         binder.eventindex{n,2} = tmp2;
      end
   end
end

