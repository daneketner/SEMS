function [E, P] = readSTPPhase (fname)
% readSTPPhase: Parse file from output of "PHASE" command in stp
% Usage:
%   [E, P] = readSTPPhase (fname)
%
%%%%% LEAP SECONDS ARE CORRECTED FOR AUTOMATICALLY %%%%%%
%
% Input:
%   fname: filename of phase file (see STP manual)
%
% Output:
%   E: structure with earthquake information
%   P: structure with phase information
%--------------------------------------------------------------------------

lineno = 1;
fid = fopen( fname );
if fid >= 3
    tline = fgetl(fid);
    while ischar(tline)
        if lineno == 1
            % Load event data
            C = textscan( tline, '%d %s %s %f %f %f %f %s %f' );
            E.evid = C{1};
            E.type = C{2}{1};
            datetemp = datenum(C{3});
            if datetemp < datenum([2012 06 08 00 00 00])
                % On June 8, 2012 at 00:00 UTC, an error in the leapseconds 
                % file was corrected. This error created a 1 second offset 
                % in data read from STP with origintimes prior to this 
                % date.  If the origin time is before June 8, then a 1 
                % second correction must be made.
                E.datenum = datetemp;
            else
                E.datenum = datetemp-1/24/60/60;
            end
            E.date = datestr(E.datenum, 31);
            E.lat = C{4};
            E.lon = C{5};
            E.depth = C{6};
            E.mag = C{7};
            E.magtype = C{8}{1};
            E.quality = C{9};
        else
            % Load phase pick data
            C = textscan( tline, '%s %s %s %s %f %f %f %s %s %s %f %f %f' );
            ind = lineno-1;
            P(ind).net = C{1}{1};
            P(ind).sta = C{2}{1};
            P(ind).chan = C{3}{1};
            P(ind).loc = C{4}{1};
            P(ind).lat = C{5};
            P(ind).lon = C{6};
            P(ind).elev = C{7};
            P(ind).phase = C{8}{1};
            P(ind).fm = C{9}{1};
            P(ind).onset = C{10}{1};
            P(ind).pQual = C{11};
            P(ind).epiDist = C{12};
            P(ind).deltaT = C{13};
            P(ind).datenum = addtodate(E.datenum, round(P(ind).deltaT*1000), 'millisecond');
        end
        lineno = lineno+1;
        tline = fgetl(fid);
    end
else
    P = struct([]);
    E = struct([]);
    return;
end
fclose(fid);
