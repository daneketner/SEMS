function [full_stk seed] = smart_stack(trig,w,left,right)

win1 = -left/24/60/60;
win2 = right/24/60/60;
nt = length(trig);
e_wfa = extract(w,'time',win1+trig,win2+trig);
sub_l = floor(sqrt(nt)); % prevent overlaoding stack.m by stacking stacks
for m = 1:floor(sub_l)
   sub_stk(m) = stack(e_wfa((m-1)*sub_l+1:m*sub_l));
end
if length(e_wfa) > m*sub_l
   sub_stk(m+1)=stack(e_wfa(m*sub_l+1:end));
end
full_stk = stack(sub_stk);

title([get(w,'station'),':',get(w,'channel'),' - ',...
       'Stack of ',num2str(nt),' similar waveforms from ',...
       datestr(get(w,'start')),' to ',datestr(get(w,'end'))])
%figure, plot(abs(full_stk))
%hh = hilbert(full_stk);
%hold on
%plot(hh,'color',[1 0 0])

max_sst = max_energy(full_stk,4);
seed = extract(full_stk,'time',max_sst(1),max_sst(2));

figure, plot(full_stk)
hold on
plot(sst2nan(max_sst,full_stk),'color',[1 0 0])
