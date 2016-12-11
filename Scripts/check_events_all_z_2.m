e.sta = {};
e.sst = {};
e_cnt = numel(e.sst)+1;

for n = 1:50%numel(sst)
w = get_red_w('z',sst(n,1)-1/24/60,sst(n,2)+1/24/60,1);
e.sta{e_cnt} = get(w,'station');
win = [sst(n,1)-.5/24/60,sst(n,2)+.5/24/60];
nw = numel(w);
e.sst{e_cnt} = cell(nw,1);  
e.sst{e_cnt}{1} = sst(n,:);
e.sst{e_cnt} = event_pick(w,'e_sst',e.sst{e_cnt},'win',win);
k = 0;
m = 1;
while m<=numel(e.sst{e_cnt})
   if ~isempty(e.sst{e_cnt}{m})
      k = 1;
      m = m + 1;
   else
      e.sst{e_cnt}(m)=[];
      e.sta{e_cnt}(m)=[];
   end
end
if k == 1
   e_cnt = e_cnt+1;
end
end

