function lightningStrikes2CSV(STK,filename)

% INPUTS:  S - structure with separate fields that are identically sized
%          filename - where to place CSV file (should end with '.csv')

fid = fopen(filename,'w+');
fprintf(fid, 'Time, Latitude, Longitude, Azimuth, Distance\n');

for n = 1:size(STK,1)
   fprintf(fid, [datestr(STK(n,1)),', %0.4f, %0.4f, %0.1f, %0.1f\n'],...
       STK(n,2), STK(n,3), STK(n,4), STK(n,5));
end
fclose(fid);

