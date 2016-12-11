function corrblock2statmaster(cb_dir,sm_dir,cc,half,range,cut)

stat = [];
cd(cb_dir)
for n = range(1):range(2)
    load(['CORR_BLOCK_',num2str(n,'%03.0f'),'.mat'])
    c = cluster(c,cc);
    curstat = getclusterstat(c,cc);
    if isempty(stat)
        maststat = curstat;
    else
        for m = 1:length(curstat)
            subcur = curstat.index{m} + (n-1)*half;
            subcurleft = subcur(subcur<=(n*half));
            subcurright = subcur(subcur>(n*half));
            maxovr = 0; maxfam = 0;
            for k = 1:numel(maststat)
                submast = maststat.index(k);
                submastright = submast(submast>((n-1)*half));
                curovr = length(intersect(stat(k),subcurleft));
                if curovr > maxovr
                    maxovr = curovr;
                    maxindex = k;
                end
            end
            if (maxovr > numel(submastright)*.75) &&...
               (maxovr > numel(subcurleft)*.75) &&...
               (maxovr > 4)
           
           %to be continued
           
            else
            end
        end
    end
end
                