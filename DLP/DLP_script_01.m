
%% DEEP LP PROJECT

% 'md' - Path to folders containing miniSEED data (.mseed)
% 'pd' - Path to STP phase files (.pha)
% 'wd' - Path to waveform object file
md = 'C:\AVO\Deep LP\DLP_mseed'; 
pd = 'C:\AVO\Deep LP\DLP_phase';
wd = 'C:\AVO\Deep LP\DLP_wfa';
% 'WD' - Structure containing names of miniSEED folders
MD = dir(md);
MD(1:2) = []; % Get rid of '.' and '..'
% 'PD' - Structure containing names of STP phase files
PD = dir(pd);
PD(1:2) = []; % Get rid of '.' and '..'

%%
Master = [];
tic
for n = 1:numel(MD)
    clc, disp(num2str(n)), pause(.01)
    id = MD(n).name;   
    wfold = fullfile(md,id);
    pfile = fullfile(pd,[id,'.pha']);
    if exist(pfile) == 2 % If a corresponding phase file exist
     % 'MDN' - Structure w/ names of miniSEED files in current folder
        MDN = dir(wfold);
        MDN(1:2) = []; % Get rid of '.' and '..'
        if ~isempty(MDN(1).name)
            [E, P] = readstpphase(pfile);

            Master.evid(n) = E.evid;
            Master.type{n} = E.type;
            Master.datenum(n) = E.datenum;
            Master.lat(n) = E.lat;
            Master.lon(n) = E.lon;
            Master.depth(n) = E.depth;
            Master.mag(n) = E.mag;
            Master.magtype{n} = E.magtype;
            Master.quality(n) = E.quality;

            pscnl = scnlobject;
            for k = 1:numel(P)
               pscnl(k) = scnlobject(P(k).sta,P(k).chan,P(k).net,P(k).loc);
            end
            W = [];
            for m = 1:numel(MDN)
                mfile = fullfile(md,id,MDN(m).name);
                w = msd2wfo(mfile);
                wscnl = get(w,'scnlobject');
                [rA, rB] = intersect(wscnl,pscnl);
                if ~isempty(rB)
                    w = addfield(w, 'evid', E.evid);
                    w = addfield(w, 'type', E.type);
                    w = addfield(w, 'ev_datenum', E.datenum);
                    w = addfield(w, 'ev_lat', E.lat);
                    w = addfield(w, 'ev_lon', E.lon);
                    w = addfield(w, 'ev_depth', E.depth);
                    w = addfield(w, 'ev_mag', E.mag);
                    w = addfield(w, 'ev_magtype', E.magtype);
                    w = addfield(w, 'ev_quality', E.quality);
                    w = addfield(w, 'sta_lat', P(rB(1)).lat);
                    w = addfield(w, 'sta_lon', P(rB(1)).lon);
                    w = addfield(w, 'sta_elev', P(rB(1)).elev);
                    w = addfield(w, 'onset', P(rB(1)).onset);
                    w = addfield(w, 'epiDist', P(rB(1)).epiDist);
                    for k = 1:numel(rB)
                        K = rB(k);
                        try
                        if strcmpi(P(K).phase,'P')
                            w = addfield(w, 'P_deltaT', P(K).deltaT);
                            w = addfield(w, 'P_datenum', P(K).datenum);
                        elseif strcmpi(P(K).phase,'S')
                            w = addfield(w, 'S_deltaT', P(K).deltaT);
                            w = addfield(w, 'S_datenum', P(K).datenum);
                        end
                        catch, end
                    end
                    W = [W w];
                    clear w
                end
            end
            cd(wd)
            save([id,'.mat'],'W')
            cd('C:\AVO\Deep LP')
            save('Master.mat','Master')
        end
    end
end
toc

