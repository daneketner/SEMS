
function drawlines(lvec, dir)
l = numel(lvec);

if strcmpi(dir,'x')
   for n=1:l
      line(get(gca,'xlim'),[lvec(n) lvec(n)],'color',[0 0 0],'linestyle','-')
   end
elseif strcmpi(dir,'y')
   for n=1:l
      line([lvec(n) lvec(n)],get(gca,'ylim'),'color',[1 0 0])
   end
end

chil = get(gca,'children');
chil = chil([l+1:end, 1:l]);
set(gca,'children',chil)


