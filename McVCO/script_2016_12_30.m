 dr = 'C:\AVO\McVCO_Metrics\WAVEFORMS\';
for year = 2012:2016
    disp year
    cd([dr,num2str(year)])
    files = dir;
    for n = 3:size(files,1)
        load(files(n).name)
        W = clearhistory(W);
        W = delfield(W,'AMP');
        W = delfield(W,'BVL');
        W = delfield(W,'GAIN');
        W = delfield(W,'ID');
        W = delfield(W,'OFF');
        W = delfield(W,'REAL_BVL');
        W = delfield(W,'REAL_GAIN');
        W = delfield(W,'REAL_ID');
        d = datevec(get(W,'start')); y = d(:,1);
        W(y~=year) = [];
        save(files(n).name,'W')
    end
end