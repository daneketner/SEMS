% VOLCANO_NETWORK: builds a structured array of all the stations within
% the Alaska Volcano Network. This program opens the text file 'AV.txt' 
% which includes all info below. Using object-oriented approach would be
% better. Also, a better way of building this virtual Matlab network is
% something to consider. All the fields generated below would ideally be 
% fetched from a network, and not from a single text fileVolcano networks 
% are dynamic, and the way they are represented programatically should 
% reflect that. A waveform object has a 'Station' field and could benefit 
% from having access to fields from a 'Station' class. The history of the
% station including installation time and known periods of outage could be 
% useful when capturing waveform data. Other fields from a 'Station' class 
% could be useful during event detection such as Lat/Long/Elev with respect 
% to other instruments within the same subnet. Fields like 'seismic 
% background level' and 'Instrument type' could prove useful for an 
% automated removal of instrument response.



%%%%%% Generates Structured Array: Net.Subnet.Station.Station_fields %%%%%%

% fid = fopen('AV.txt');
% 
% C = textscan(fid,'%s %s %s %s %s %s %s %s %s %s');
% fclose(fid);
% 
% Net = C{1,1}; 
% Subnet = C{1,2};
% Station = C{1,3};
% Lat_Deg = C{1,4};
% Lat_Min = C{1,5};
% Long_Deg = C{1,6};
% Long_Min = C{1,7};
% Elevation = C{1,8};
% Instrument = C{1,9};
% Channels = C{1,10};
% 
% for n = 1:length(Net)
%    nss = [Net{n},'.',Subnet{n},'.',Station{n}];
%    eval([nss,'.Lat = [',Lat_Deg{n},' ',Lat_Min{n},']']); 
%    eval([nss,'.Long = [',Long_Deg{n},' ',Long_Min{n},']']); 
%    eval([nss,'.Elev = ',Elevation{n}]); 
%    eval([nss,'.Inst = ''',Instrument{n},'''']);
%    chan(n) = textscan(Channels{n},'%s','delimiter',',');
%    for m = 1:length(chan{n})
%       eval([nss,'.Chan(m,:) = ''',chan{n}{m},'''']);
%    end 
% end
% 
% clear C fid Net Subnet Station Lat_Deg Lat_Min Long_Deg Long_Min Elevation...
%       Instrument Channels nss chan m n ans
% clc

%%%%%%%%% Generates Structured Array: Net.Station.Station_fields %%%%%%%%%%

fid = fopen('AV.txt');

C = textscan(fid,'%s %s %s %s %s %s %s %s %s %s');
fclose(fid);

Net = C{1,1}; 
Station = C{1,3};
Lat_Deg = C{1,4};
Lat_Min = C{1,5};
Long_Deg = C{1,6};
Long_Min = C{1,7};
Elevation = C{1,8};
Instrument = C{1,9};
Channels = C{1,10};

for n = 1:length(Net)
   ns = [Net{n},'.',Station{n}];
   eval([ns,'.Lat = [',Lat_Deg{n},' ',Lat_Min{n},']']); 
   eval([ns,'.Long = [',Long_Deg{n},' ',Long_Min{n},']']); 
   eval([ns,'.Elev = ',Elevation{n}]); 
   eval([ns,'.Inst = ''',Instrument{n},'''']);
   chan(n) = textscan(Channels{n},'%s','delimiter',',');
   for m = 1:length(chan{n})
      eval([ns,'.Chan(m,:) = ''',chan{n}{m},'''']);
   end 
end

clear C fid Net Station Lat_Deg Lat_Min Long_Deg Long_Min Elevation...
      Instrument Channels ns chan m n ans
clc