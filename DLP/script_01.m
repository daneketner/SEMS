
%% CONVERT .TXT FILE OF EVENT IDs TO MATLAB ARRAY
fid = fopen('missingWaves.txt');
tline = fgetl(fid);
ID = [];
while ischar(tline)
    if length(tline)==8
        ID = [ID str2double(tline)];
    end
    tline = fgetl(fid);
end
fclose(fid);

%% MAKE .TXT FILE OF EVENT IDs WITH MISSING PICK INFO

fil = 'C:\AVO\Deep LP\missingPicks.txt'; 
md = 'C:\AVO\Deep LP\DLP_phase_No_Picks'; 
MD = dir(md);
MD(1:2) = []; % Get rid of '.' and '..'
for n = 1:2065
    id(n) = str2double(MD(n).name(1:end-4));   
end
dlmwrite(fil, id,'delimiter','\n','precision','%d');

%% MAKE .TXT FILE OF EVENT IDs WITH MISSING PICK INFO

wd = 'C:\AVO\Deep LP\DLP_wfa'; 
cd(wd)
WD = dir(wd);
WD(1:2) = []; % Get rid of '.' and '..'
for n = 1:numel(WD)
    disp(n)
    load(WD(n).name); 
    for m = 1:numel(W)
    W(m) = set(W(m),'station',strtrim(get(W(m),'station')));
    W(m) = set(W(m),'channel',strtrim(get(W(m),'channel')));
    W(m) = set(W(m),'network',strtrim(get(W(m),'network')));
    end
    save(WD(n).name,'W')
    clear W
end
