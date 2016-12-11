
%%

for n = 1:numel(F.T)
   k=2;
   while k < numel(F.T{n})
      if abs(F.T{n}(k) - F.T{n}(k-1)) < 7/24/60/60
         F.T{n}(k) = [];
         F.I{n}(k) = [];
      else
         k = k+1;
      end
   end
   F.numel(n) = numel(F.T{n});
   F.start(n) = F.T{n}(1);
   F.end(n) =  F.T{n}(end);
end