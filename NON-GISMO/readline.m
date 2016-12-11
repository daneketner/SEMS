function L = readline(file)

fid = fopen(file);
line = fgetl(fid);
while ischar(line)
    C = textscan(line, '%s');
    if strcmp(C{1},'00000000000000000000000')
        line = fgetl(fid);
        break
    else
        line = fgetl(fid);
    end
end
k = 1;
L(k).lat = [];
L(k).lon = [];
while ischar(line)
    C = textscan(line, '%f %f %f %f %f %f %f %f');
    if C{1} == 0
        flonbig = find(abs(L(k).lon) > 360);
        L(k).lon(flonbig) = L(k).lon(flonbig)*1e-6;
        flatbig = find(abs(L(k).lat) > 360);
        L(k).lat(flatbig) = L(k).lat(flatbig)*1e-6;
        f = find(L(k).lon > 0);
        L(k).lon(f) = L(k).lon(f)-360;
        line = fgetl(fid);
        k = k+1;
        L(k).lat = [];
        L(k).lon = [];
    else
        for n =1:8
            if rem(n,2) == 1
                L(k).lat = [L(k).lat C{n}];
            else
                L(k).lon = [L(k).lon -C{n}];
            end
        end
        line = fgetl(fid);
    end
end