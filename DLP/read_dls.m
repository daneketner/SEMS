function [net] = read_dls (fname)
% read_dls: Read Dataless SEED file
%
% Usage:
%
% Input:
%
% Output:


fid = fopen(fname);
big_str = fgetl(fid);
done = 0;
r = 3;
n = 1;
while~done
    sml_str = [sprintf('%06d',r),'S '];
    k = strfind(big_str, sml_str);
    if isempty(k)
        r = r+1;
    else
        k = k(1);
        net(n).sta = strtrim(big_str(k+15:k+18));
        net(n).lat = str2double(big_str(k+21:k+29));
        net(n).lon = str2double(big_str(k+30:k+40));
        net(n).elev = str2double(big_str(k+42:k+45));
        r = r+1;
        n = n+1;
    end
    if r>255
        break
    end
end
fclose(fid);

