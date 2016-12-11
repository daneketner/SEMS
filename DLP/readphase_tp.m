function [E, P] = readphase_tp (fname,net)
% readSTPPhase: Parse file from output of tparker phase files
% Usage:
%   [E, P] = readstpphase_02 (fname)
%
% Input:
%   fname: filename of phase file (see STP manual)
%
% Output:
%   E: structure with earthquake information
%   P: structure with phase information
%--------------------------------------------------------------------------

fid = fopen(fname);

if fid >= 3
    for k = 1:4
        tline = fgetl(fid);
    end
    C = textscan( tline, '%s %s %s %f %f %f %f %f %s %f' );
    E.evid = str2double(fname(end-11:end-4));
    E.type = C{1}{:};
    E.datestr = [C{2}{:},' ',C{3}{:}];
    E.datenum = datenum(E.datestr);
    E.lat = C{4};
    E.lon = C{5};
    E.depth = C{6};
    E.quality = C{7};
    E.mag = C{8};
    E.magtype = C{9}{:};
    E.orid = C{10};
    for k = 1:5
        tline = fgetl(fid);
    end
    ind = 1;
    while ischar(tline) && numel(tline)>0
        C = textscan(tline, '%s %s %s %s %s %s %s %f %s %s');
        P(ind).net = C{1}{1};
        P(ind).sta = C{2}{1};
        found = 0;
        k = 1;
  
        while ~found && k<=numel(net)
            if strcmp(net(k).sta,P(ind).sta)
                found = 1;
                P(ind).lat = net(k).lat;
                P(ind).lon = net(k).lon;
                P(ind).elev = net(k).elev;
                P(ind).epiDist = sqrt((111*(P(ind).lat - E.lat))^2 + ...
                    (64*(P(ind).lon - E.lon))^2 + ...
                    (P(ind).elev + E.depth)^2);
            else
                k = k+1;
            end
        end
        P(ind).chan = C{3}{1};
        P(ind).loc = '';
        P(ind).phase = C{4}{1};
        P(ind).datestr = [C{5}{1},' ',C{6}{1}];
        P(ind).datenum = datenum(P(ind).datestr);
        P(ind).deltaT = P(ind).datenum - E.datenum;
        %P(ind).rf = C{7}{1};
        %P(ind).qual = C{8};
        %P(ind).fm = C{9}{1};
        %P(ind).q = C{10}{1};
        tline = fgetl(fid);
        ind = ind+1;
    end
    fclose(fid);
end

if ~exist('P'), P = []; end
if ~exist('E'), E = []; end

