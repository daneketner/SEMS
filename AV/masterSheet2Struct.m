function S = masterSheet2Struct(src)

S = [];
switch src
case 'DIG-SEIS'
%% DIGITAL SEISMIC SITES

DOCID = '15znPpaFRNCIIK_g-F7SoRI70br9PBuDHxilaJYQ4v2k';
result = GetGoogleSpreadsheet(DOCID);
for n = 2:size(result,1)
    site = strrep(result{n,1}, '-', '_');
    S.(site).AKA = result{n,2};
    S.(site).StationName = result{n,3};
    S.(site).Network = result{n,4};
    S.(site).Subnet = result{n,5};
    S.(site).Elevft = str2double(result{n,6});
    S.(site).LatitudeWG84 = str2double(result{n,7});
    S.(site).LongitudeWG84 = str2double(result{n,8}); 
    S.(site).DateOpened = result{n,9};
    S.(site).Components = result{n,10};
    S.(site).SeisMake = result{n,11};
    S.(site).SeisModel = result{n,12};
    S.(site).SeisSerial = result{n,13};
    S.(site).DigMake = result{n,14};
    S.(site).DigModel = result{n,15};
    S.(site).DigSerial = result{n,16}; 
    S.(site).SampleRate = str2double(result{n,17});
    S.(site).RxSiteCode = strrep(result{n,18}, '-', '_');
    S.(site).FreqMHz = str2double(result{n,19});
    S.(site).Polarity = result{n,20};
    S.(site).Azimuth = str2double(result{n,21});
    S.(site).DistanceMiles = str2double(result{n,22});
    S.(site).SitePhotosURL = result{n,23}; 
    S.(site).IcingaURL = result{n,24};
    S.(site).TelemDiagURL = result{n,25};
    S.(site).VoltagesURL = result{n,26};
    S.(site).OutageMapURL = result{n,27};
end

case 'ANA-SEIS'
%% ANALOG SEISMIC SITES

DOCID = '1-_NKI_vCYKDACAxHowfrx8HDasHSBl4sA1Wk7-WuKPk';
result = GetGoogleSpreadsheet(DOCID);
for n = 2:size(result,1)
    site = strrep(result{n,1}, '-', '_');
    S.(site).StationName = result{n,2};
    S.(site).Network = result{n,3};
    S.(site).Subnet = result{n,4};
    S.(site).Elevft = str2double(result{n,5});
    S.(site).LatitudeWG84 = str2double(result{n,6});
    S.(site).LongitudeWG84 = str2double(result{n,7}); 
    S.(site).DateOpened = result{n,8};
    S.(site).Components = result{n,9};
    S.(site).SeisModel = result{n,10};
    S.(site).SeisSerial = result{n,11}; 
    S.(site).SampleRate = str2double(result{n,12});
    S.(site).RxSiteCode = strrep(result{n,13}, '-', '_');
    S.(site).FreqMHz = str2double(result{n,14});
    S.(site).Polarity = result{n,15};
    S.(site).Azimuth = str2double(result{n,16});
    S.(site).DistanceMiles = str2double(result{n,17});
    S.(site).SitePhotosURL = result{n,18};
    S.(site).VoltagesURL = result{n,19};
    S.(site).WaveformsURL = result{n,20};
    S.(site).TelemDiagURL = result{n,21};
    S.(site).McVCOSerialE = str2double(result{n,22});
    S.(site).McVCOSerialN = str2double(result{n,23});
    S.(site).McVCOSerialZ = str2double(result{n,24});    
    S.(site).McVCOFreqE = str2double(result{n,25});
    S.(site).McVCOFreqN = str2double(result{n,26});
    S.(site).McVCOFreqZ = str2double(result{n,27});
    S.(site).McVCOGainE = str2double(result{n,28});
    S.(site).McVCOGainN = str2double(result{n,29});
    S.(site).McVCOGainZ = str2double(result{n,30});
end  

case 'DIG-REP'
%% DIGITAL REPEATERS 

DOCID = '1IIvEk4MMj0xsxpsaJ117U9Poh4eYHnIprB0DMAcxMhk';
result = GetGoogleSpreadsheet(DOCID);
for n = 2:size(result,1)
    site = strrep(result{n,1}, '-', '_');
    S.(site).SiteName = result{n,2};
    S.(site).Owner = result{n,3};
    S.(site).Elevft = str2double(result{n,4});
    S.(site).LatitudeWG84 = str2double(result{n,5});
    S.(site).LongitudeWG84 = str2double(result{n,6});  
    S.(site).RxSiteCode = strrep(result{n,7}, '-', '_');
    S.(site).Azimuth = str2double(result{n,8});
    S.(site).DistanceMiles = str2double(result{n,9});
    S.(site).SitePhotosURL = result{n,10};
    S.(site).TelemDiagURL = result{n,11};
    S.(site).IcingaURL = result{n,12};
    S.(site).VoltagesURL = result{n,13};
end

case 'ANA-REP'
%% ANALOG REPEATERS   

DOCID = '1zkZWnRg83dJeTv_Lr5ZVXKYpryJHcFh5mxGERcxIOfo';
result = GetGoogleSpreadsheet(DOCID);
for n = 2:size(result,1)
    site = strrep(result{n,1}, '-', '_');
    S.(site).SiteName = result{n,2};
    S.(site).Owner = result{n,3};
    S.(site).Elevft = str2double(result{n,4});
    S.(site).LatitudeWG84 = str2double(result{n,5});
    S.(site).LongitudeWG84 = str2double(result{n,6});  
    S.(site).RxSiteCode = strrep(result{n,7}, '-', '_');
    S.(site).Azimuth = str2double(result{n,8});
    S.(site).DistanceMiles = str2double(result{n,9});
    S.(site).SitePhotosURL = result{n,10};
    S.(site).TelemDiagURL = result{n,11};
end

case 'DIG-RAD'
%% DIGITAL RADIOS   

DOCID = '1HhRcPQ-pKd1COw60hm_8iJhIyC9SSL1Ug5Zd2b_SCqw';
result = GetGoogleSpreadsheet(DOCID);
for n = 4:size(result,1)
    site = strrep(result{n,1}, '-', '_');
    radio = result{n,2};
    if ~isempty(site) && ~isempty(radio)
    S.(site).(radio).Owner = result{n,3};
    S.(site).(radio).Make = result{n,4};
    S.(site).(radio).Model = result{n,5};
    S.(site).(radio).RxRadioCode = strrep(result{n,6}, '-', '_');
    S.(site).(radio).SN = result{n,7};
    S.(site).(radio).MAC = result{n,8};
    S.(site).(radio).IPAddress = result{n,9};
    S.(site).(radio).Port = str2double(result{n,10});
    S.(site).(radio).SubnetMask = result{n,11};
    S.(site).(radio).Gateway = result{n,12};
    S.(site).(radio).PPPMP = result{n,13};
    S.(site).(radio).GER = result{n,14};
    S.(site).(radio).FKey = result{n,15};
    S.(site).(radio).NetID = result{n,16};
    S.(site).(radio).SNRxTx = result{n,17};
    S.(site).(radio).TYPE = result{n,18};
    S.(site).(radio).Polarity = result{n,19};
    S.(site).(radio).Port1 = str2double(result{n,20});
    S.(site).(radio).Baud1 = str2double(result{n,21});
    S.(site).(radio).Dev1 = result{n,22};
    S.(site).(radio).Port2 = str2double(result{n,23});
    S.(site).(radio).Baud2 = str2double(result{n,24});
    S.(site).(radio).Dev2 = result{n,25};
    end
end

case 'CAMERA'
%% CAMERAS  

DOCID = '1nF-NzEWbbEpnvj1PWGn_vzKXIkdEp38sDWzCdei8-f0';
result = GetGoogleSpreadsheet(DOCID);
for n = 2:size(result,1)
    site = strrep(result{n,2}, '-', '_');
    S.(site).Volcano = result{n,3};
    S.(site).CamName = result{n,4};    
    S.(site).Elevft = str2double(result{n,5});
    S.(site).LatitudeWG84 = str2double(result{n,6});
    S.(site).LongitudeWG84 = str2double(result{n,7});  
    S.(site).RxSiteCode = strrep(result{n,8}, '-', '_');
    S.(site).Azimuth = str2double(result{n,9});
    S.(site).DistanceMiles = str2double(result{n,10});
    S.(site).ImageAzimuth = str2double(result{n,11});
    S.(site).ImageRes = str2double(result{n,12}); 
    S.(site).CurrentImage = result{n,13};
    S.(site).SitePhotosURL = result{n,14};
    S.(site).TelemDiagURL = result{n,15};
    S.(site).IcingaURL = result{n,16}; 
end 

case 'RX'
%% RX FACILITIES

DOCID = '1kUsGDttvrlhzPMYEhq3uy1mBHPNAeeE3PhfBPe1W6bc';
result = GetGoogleSpreadsheet(DOCID);
for n = 2:size(result,1)
    site = strrep(result{n,2}, '-', '_');
    S.(site).Town = result{n,3};
    S.(site).Facility = result{n,4};    
    S.(site).Elevft = str2double(result{n,5});
    S.(site).LatitudeWG84 = str2double(result{n,6});
    S.(site).LongitudeWG84 = str2double(result{n,7});  
    S.(site).SitePhotosURL = result{n,8};
    S.(site).IcingaURL = result{n,9}; 
    S.(site).DocuURL = result{n,10};
    S.(site).TelemDiagURL = result{n,11};
    S.(site).ContactName = result{n,12};
    S.(site).ContactPhone = result{n,13};
    S.(site).ContactDetails = result{n,14};
end    

otherwise
end




