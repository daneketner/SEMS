%% RX
RX = [];
for n = 1:numel(SiteCode)
    site = strrep(SiteCode{n}, '-', '_');
    RX.(site).Elevft = Elevft(n);
    RX.(site).LatitudeWG84 = LatitudeWG84(n);
    RX.(site).LongitudeWG84 = LongitudeWG84(n);  
    RX.(site).Town = Town{n};
    RX.(site).Facility = Facility{n};
    RX.(site).SitePhotosURL = SitePhotos{n}; 
    RX.(site).TelemDiagURL = TelemetryDiagram{n};
    RX.(site).IcingaURL = Icinga{n};
    RX.(site).DocuURL = NetworkCircuitDocu{n};
    RX.(site).ContactName = Name{n};
    RX.(site).ContactPhone = Phone1{n};
    RX.(site).ContactDetails = Details1{n};
end
clear n site SiteCode SiteName Elevft LatitudeWG84 LongitudeWG84 Town Facility...
      Details1 Icinga Name NetworkCircuitDocu Phone1 SitePhotos TelemetryDiagram Details1

%% REP
REP = [];
for n = 1:numel(SiteCode)
    site = strrep(SiteCode{n}, '-', '_');
    REP.(site).SiteName = SiteName{n};
    REP.(site).Elevft = Elevft(n);
    REP.(site).LatitudeWG84 = LatitudeWG84(n);
    REP.(site).LongitudeWG84 = LongitudeWG84(n);  
    REP.(site).RxSiteCode = strrep(RxSiteCode{n}, '-', '_');
    REP.(site).Owner = Owner{n};
    REP.(site).Azimuth = Azimuth(n);
    REP.(site).DistanceMiles = DistanceMiles(n);
    REP.(site).SitePhotosURL = SitePhotos{n}; 
    REP.(site).TelemDiagURL = TelemetryDiagram{n};
    REP.(site).VoltagesURL = Voltages{n};
    REP.(site).IcingaURL = Icinga{n};    
end
clear n site SiteCode SiteName Elevft LatitudeWG84 LongitudeWG84 LongitudeWG84 RxSiteCode...
      RxSiteName Azimuth DistanceMiles SitePhotos TelemetryDiagram Icinga Voltages Owner

%% DIGITAL
DIG = [];
for n = 1:numel(StationCode)
    site = strrep(StationCode{n}, '-', '_');
    DIG.(site).StationName = StationName{n};
    DIG.(site).Network = Network{n};
    DIG.(site).Subnet = Subnet{n};
    DIG.(site).Elevft = Elevft(n);
    DIG.(site).LatitudeWG84 = LatitudeWG84(n);
    DIG.(site).LongitudeWG84 = LongitudeWG84(n);  
    DIG.(site).DateOpened = DateOpened(n);
    DIG.(site).Components = Components{n};
    DIG.(site).SeisMake = SeisMake{n};
    DIG.(site).SeisModel = SeisModel{n};
    DIG.(site).SeisSerial = SeisSerial{n};
    DIG.(site).DigMake = DigMake{n};
    DIG.(site).DigModel = DigModel{n};
    DIG.(site).DigSerial = DigSerial{n}; 
    DIG.(site).SampleRate = SampleRate(n);
    DIG.(site).RxSiteCode = strrep(RxSiteCode{n}, '-', '_');
    DIG.(site).FreqMHz = FreqMHz(n);
    DIG.(site).Polarity = Polarity{n};
    DIG.(site).Azimuth = Azimuth(n);
    DIG.(site).DistanceMiles = DistanceMiles(n);
    DIG.(site).SitePhotosURL = SitePhotos{n}; 
    DIG.(site).TelemDiagURL = TelemetryDiagram{n};
    DIG.(site).VoltagesURL = Voltages{n};
    DIG.(site).OutageMapURL = OutageMap{n};
    DIG.(site).IcingaURL = Icinga{n};
end
clear n site StationName StationCode Network Subnet Elevft LatitudeWG84 LongitudeWG84...   
    DateOpened Components SeisMake SeisModel SeisSerial DigMake DigModel... 
    DigSerial SampleRate RxSiteCode FreqMHz Polarity Azimuth ...
    DistanceMiles SitePhotos TelemetryDiagram Voltages OutageMap Icinga

%% ANALOG
ANA = [];
for n = 1:numel(StationCode)
    site = strrep(StationCode{n}, '-', '_');
    ANA.(site).StationName = StationName{n};
    ANA.(site).Network = Network{n};
    ANA.(site).Subnet = Subnet{n};
    ANA.(site).Elevft = Elevft(n);
    ANA.(site).LatitudeWG84 = LatitudeWG84(n);
    ANA.(site).LongitudeWG84 = LongitudeWG84(n);  
    ANA.(site).DateOpened = DateOpened(n);
    ANA.(site).Components = Components{n};
    ANA.(site).SeisModel = SeisModel{n};
    ANA.(site).SeisSerial = SeisSerial(n); 
    ANA.(site).SampleRate = SampleRate(n);
    ANA.(site).RxSiteCode = strrep(RxSiteCode{n}, '-', '_');
    ANA.(site).FreqMHz = FreqMHz(n);
    ANA.(site).Polarity = Polarity{n};
    ANA.(site).Azimuth = Azimuth(n);
    ANA.(site).DistanceMiles = DistanceMiles(n);
    ANA.(site).McVCOFreqE = McVCOFreqE(n);
    ANA.(site).McVCOFreqN = McVCOFreqN(n);
    ANA.(site).McVCOFreqZ = McVCOFreqZ(n);
    ANA.(site).McVCOGainE = McVCOGainE(n);
    ANA.(site).McVCOGainN = McVCOGainN(n);
    ANA.(site).McVCOGainZ = McVCOGainZ(n);
    ANA.(site).McVCOSerialE = McVCOSNE(n);
    ANA.(site).McVCOSerialN = McVCOSNN(n);
    ANA.(site).McVCOSerialZ = McVCOSNZ(n);
    ANA.(site).TelemDiagURL = TelemetryDiagram{n};
    ANA.(site).SitePhotosURL = SitePhotos{n};
    ANA.(site).VoltagesURL = Voltages{n};
    ANA.(site).WaveformsURL = CalPulseWaveforms{n};    
        
end
clear n site StationName StationCode Network Subnet Elevft LatitudeWG84 LongitudeWG84...   
    DateOpened Components SeisMake SeisModel SeisSerial DigMake DigModel... 
    DigSerial SampleRate RxSiteCode FreqMHz Polarity Azimuth DistanceMiles...
    McVCOFreqE McVCOFreqN McVCOFreqZ McVCOGainE McVCOGainN McVCOGainZ...
    McVCOSNE McVCOSNN McVCOSNZ Network TelemetryDiagram Voltages ...
    CalPulseWaveforms SitePhotos

%% RADIO
RAD = [];
for n = 1:numel(SiteCode)
    site = strrep(SiteCode{n}, '-', '_');
    RAD.(site).(RadioCode{n}).Owner = Owner{n};
    RAD.(site).(RadioCode{n}).Make = Make{n};
    RAD.(site).(RadioCode{n}).Model = Model{n};
    RAD.(site).(RadioCode{n}).RxRadioCode = strrep(RxRadioCode{n}, '-', '_');
    RAD.(site).(RadioCode{n}).SN = SN(n);
    RAD.(site).(RadioCode{n}).MAC = MAC{n};
    RAD.(site).(RadioCode{n}).IPAddress = IPAddress{n};
    RAD.(site).(RadioCode{n}).Port = Port(n);
    RAD.(site).(RadioCode{n}).SubnetMask = SubnetMask{n};
    RAD.(site).(RadioCode{n}).Gateway = Gateway{n};
    RAD.(site).(RadioCode{n}).PPPMP = PPPMP{n};
    RAD.(site).(RadioCode{n}).GER = GER{n};
    RAD.(site).(RadioCode{n}).FKey = FKey{n};
    RAD.(site).(RadioCode{n}).NetID = NetID(n);
    RAD.(site).(RadioCode{n}).SNRxTx = SNRxTx{n};
    RAD.(site).(RadioCode{n}).TYPE = TYPE{n};
    RAD.(site).(RadioCode{n}).Polarity = Polarity{n};
    RAD.(site).(RadioCode{n}).Azimuth = Azimuth(n);
    RAD.(site).(RadioCode{n}).Port1 = Port1(n);
    RAD.(site).(RadioCode{n}).Baud1 = Baud1(n);
    RAD.(site).(RadioCode{n}).Dev1 = Dev1{n};
    RAD.(site).(RadioCode{n}).Port2 = Port2(n);
    RAD.(site).(RadioCode{n}).Baud2 = Baud2(n);
    RAD.(site).(RadioCode{n}).Dev2 = Dev2{n};
end
clear n Owner Make Model RxRadioCode SN MAC IPAddress Port SubnetMask...
      Gateway PPPMP GER FKey NetID SNRxTx TYPE Polarity Azimuth Port1...
      Baud1 Dev1 Port2 Baud2 Dev2 site RadioCode SiteCode ans




