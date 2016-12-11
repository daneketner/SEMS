function EM = create_event_master
%  INITIALIZE EVENT STRUCTURE - LOOP OVER ALL MINISEED FILES IN DIRECTORY & 
%  MATCH THEM TO CORRESPONDING PHASE FILES. SAVE EVENT/LOCATION FIELDS IN
%  EVENT MASTER (EM) STRUCTURE. CONVERT MINISEED FILES TO WAVEFORM OBJECTS
%  AND STORE ALL EVENT & STATION DATA INSIDE EACH WAVEFORM OBJECT.

Dir = make_dir_mstr;
% 'MD' - Structure containing names of miniSEED folders
MD = dir(Dir.Msd);
MD(1:2) = []; % Get rid of '.' and '..'
% 'PD' - Structure containing names of STP phase files
PD = dir(Dir.Pha);
PD(1:2) = []; % Get rid of '.' and '..'
EM = [];
for n = 1:numel(MD)
    clc, disp(num2str(n)), pause(.01)
    id = MD(n).name;
    wfold = fullfile(Dir.Msd,id);
    pfile = fullfile(Dir.Pha,[id,'.pha']);
    if exist(pfile) == 2 % If a corresponding phase file exist
        % 'MDN' - Structure w/ names of miniSEED files in current folder
        MDN = dir(wfold);
        MDN(1:2) = []; % Get rid of '.' and '..'
        if ~isempty(MDN(1).name)
            % The function 'readphase' depends on the phase file format
            % readphase_tp was put together to read the phase files that
            % Tom Parker was generating from DB querries
            [E, P] = readphase_tp(pfile,net);
            if ~isempty(P) && ~isempty(E)
                EM.evid(n) = E.evid;
                EM.type{n} = E.type;
                EM.datenum(n) = E.datenum;
                EM.lat(n) = E.lat;
                EM.lon(n) = E.lon;
                EM.depth(n) = E.depth;
                EM.mag(n) = E.mag;
                EM.magtype{n} = E.magtype;
                EM.quality(n) = E.quality;
                pscnl = scnlobject;
                for k = 1:numel(P)
                    pscnl(k) = scnlobject(P(k).sta,P(k).chan,...
                                          P(k).net,P(k).loc);
                end
                W = [];
                for m = 1:numel(MDN)
                    mfile = fullfile(Dir.Msd,id,MDN(m).name);
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
                        w = addfield(w, 'sta_lat', P(rB(1)).lat);
                        w = addfield(w, 'sta_lon', P(rB(1)).lon);
                        w = addfield(w, 'sta_elev', P(rB(1)).elev);
                        w = addfield(w, 'epiDist', P(rB(1)).epiDist);
                        for k = 1:numel(rB)
                            K = rB(k);
                            if strcmpi(P(K).phase,'P')
                                w = addfield(w, 'P_deltaT', P(K).deltaT);
                                w = addfield(w, 'P_datenum', P(K).datenum);
                            elseif strcmpi(P(K).phase,'S')
                                w = addfield(w, 'S_deltaT', P(K).deltaT);
                                w = addfield(w, 'S_datenum', P(K).datenum);
                            end
                        end
                        W = [W w];
                        clear w
                    end
                end
                T = get(W,'start');
                [val, ind] = sort(T);
                W = W(ind);
                EM = compute_freq(EM,W,n);
                save([Dir.Evt_Wav,'\',id,'.mat'],'W')
                save([Dir.Mst,'\Evt_Mst.mat'],'EM')
            end
        end
    end
end

function EM = compute_freq(EM,W,n)
%% COMPUTE MEDIAN, & STACKED FREQUENCY - STORE IN 'EM'
W = W(isvertical(W));
P = get_picks(W,'p');
W = W(find(P));
P = P(find(P));
fftA = zeros(1,512);
for m = 1:numel(W)
    w = extract(W(m),'TIME',P(m),P(m)+20.48/24/60/60);
    w = filt(w,'hp',.5);
    f = get(w,'freq');
    if round(f) == 50
        [A, F] = pos_fft(w,'nfft',1024,'fr',[0 25],'taper',.025);
        A = [A; 0];
        F = [F; 0];
        fftA(m,:) = A(1:512)./nanmean(A(1:512));
    elseif round(f) == 100
        [A, F] = pos_fft(w,'nfft',2048,'fr',[0 25],'taper',.025);
        A = [A; 0];
        F = [F; 0];
        fftA(m,:) = A(1:512)./nanmean(A(1:512));
    end
end
[V R] = nanmax(fftA');
EM.pfmed(n) = nanmedian(F(R));
[V R] = nanmax(sum(fftA));
EM.pfstk(n) = F(R);
