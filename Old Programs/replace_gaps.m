function [vv,gap_r,no_end] = replace_gaps(v,Fs)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Find Gaps %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

fprintf('Finding Data Gaps...\n')
vv=v;
in_gap = 0;  %0 before/after gap, 1 during gap
gap_r = [];  %Gap Record - Format:[1st gap start, 1st gap end, 2nd gap start,...]

for n=1:length(vv)
    if vv(n)<-1e9           %Gap points are very large and negative
        if in_gap == 0     %First data point in gap?
            in_gap = 1;
            gap_r = [gap_r n];
        end
    elseif in_gap == 1     %First data point after gap?
        in_gap = 0;
        gap_r = [gap_r n];
    end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Replace Gaps %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

no_end = 0;                 
if mod(length(gap_r),2) == 1 %If gap_r is odd (End of last gap not in data set)
    no_end = 1;
end

if isempty(gap_r) == 1
     fprintf('No Gaps Found\n') 
else                             
     for n=1:floor(length(gap_r)/2)         %Only operate on pairs of data
         g_1 = gap_r(n);                    %Beginning of Gap
         g_2 = gap_r(n+1);                  %End of Gap
         gap_l = g_2-g_1+1;                 %Length of gap in question
         m_1 = mean(vv(g_1-Fs:g_1-1));      %Mean before gap
         m_2 = mean(vv(g_2+1:g_2+Fs));      %Mean after gap
         vv(g_1:g_2) = linspace(m_1, m_2, gap_l)';  %Linear fit between means
         sd_1 = std(vv(g_1-gap_l:g_1-1));
         sd_2 = std(vv(g_2+1:g_2+gap_l));
         sd_g = (sd_1+sd_2)/2;
         rr=(rand(1,gap_l)-.5)*2.5*sd_g;
         rr = conv(rr, gausswin(10));
         rr = rr(1:length(rr)-10+1);
         vv(g_1:g_2) = vv(g_1:g_2)+rr';
     end
end

