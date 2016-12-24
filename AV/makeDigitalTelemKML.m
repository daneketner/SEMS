
%% MAKE DIGITAL TELEMETRY KML FILE

ST = fieldnames(RAD);
fid1 = fopen('C:\AVO\Github\SEMS\AV\digitalTelemetry.kml','w+');

fprintf(fid1,'<?xml version=''1.0'' encoding=''UTF-8''?>\n')
fprintf(fid1,'<kml xmlns=''http://www.opengis.net/kml/2.2''>\n')
fprintf(fid1,'	<Document>\n')
fprintf(fid1,'		<name>Digital Telemetry</name>\n')

for n = 1:numel(ST)
    for m = 1:numel()
    Sta = ST{n};
    
    lat1 = DIG.(Sta).LatitudeWG84;
    lon1 = DIG.(Sta).LongitudeWG84;
    RxSite =  DIG.(Sta).RxSiteCode;
    switch lower(RxSite(end-2:end))
        case{'_rx'}
            lat2 = RX.(RxSite).LatitudeWG84;
            lon2 = RX.(RxSite).LongitudeWG84;
        case{'rep'}
            if strcmp(RxSite(end-3),'_')
                lat2 = REP.(RxSite).LatitudeWG84;
                lon2 = REP.(RxSite).LongitudeWG84;
            else
                lat2 = DIG.(RxSite).LatitudeWG84;
                lon2 = DIG.(RxSite).LongitudeWG84;
            end
        otherwise
            lat2 = DIG.(RxSite).LatitudeWG84;
            lon2 = DIG.(RxSite).LongitudeWG84;
    end
    lat1 = num2str(lat1);
    lon1 = num2str(lon1);
    lat2 = num2str(lat2);
    lon2 = num2str(lon2);

    fprintf(fid1,['		<Placemark>\n'])
    fprintf(fid1,['			<name>',Sta,' to ',RxSite,'</name>\n'])
%     fprintf(fid1,['			<description><![CDATA['...
%                                     'Frequency (MHz): ',num2str(DIG.(Sta).FreqMHz),'<br>'...
%                                            'Polarity: ',DIG.(Sta).Polarity,'<br>'...
%                                    'Distance (miles): ',num2str(DIG.(Sta).DistanceMiles),'<br>'...
%                                             'Azimuth: ',num2str(DIG.(Sta).Azimuth),'<br>'...
%                                   'Telemetry Diagram: ',DIG.(Sta).TelemDiagURL,'<br>'...
%                        ']]></description>\n'])
    fprintf(fid1,['			<styleUrl>#line-A52714-3</styleUrl>\n'])
    fprintf(fid1,['			<ExtendedData>\n'])
    fprintf(fid1,['				<Data name=''Distance (Miles)''>\n'])
    fprintf(fid1,['					<value>',num2str(DIG.(Sta).FreqMHz),'</value>\n'])
    fprintf(fid1,['				</Data>\n'])
    fprintf(fid1,['				<Data name=''Azimuth''>\n'])
    fprintf(fid1,['					<value>',DIG.(Sta).Polarity,'</value>\n'])
    fprintf(fid1,['				</Data>\n'])
    fprintf(fid1,['				<Data name=''Distance (miles)''>\n'])
    fprintf(fid1,['					<value>',num2str(DIG.(Sta).DistanceMiles),'</value>\n'])
    fprintf(fid1,['				</Data>\n'])
    fprintf(fid1,['				<Data name=''Azimuth''>\n'])
    fprintf(fid1,['					<value>',num2str(DIG.(Sta).Azimuth),'</value>\n'])
    fprintf(fid1,['				</Data>\n'])
    fprintf(fid1,['				<Data name=''Telemetry Diagram''>\n'])
    fprintf(fid1,['					<value>',DIG.(Sta).TelemDiagURL,'</value>\n'])
    fprintf(fid1,['				</Data>\n'])
    fprintf(fid1,['			</ExtendedData>\n'])
    fprintf(fid1,['			<LineString>\n'])
    fprintf(fid1,['				<tessellate>1</tessellate>\n'])
    fprintf(fid1,['				<coordinates>',lon1,',',lat1,',0.0 ',lon2,',',lat2,',0.0</coordinates>\n'])
    fprintf(fid1,['			</LineString>\n'])
    fprintf(fid1,['		</Placemark>\n'])
    fprintf(fid1,'\n')
    end 
end

fprintf(fid1,'		<Style id=''line-A52714-3-normal''>\n')
fprintf(fid1,'			<LineStyle>\n')
fprintf(fid1,'				<color>ff1427A5</color>\n')
fprintf(fid1,'				<width>3</width>\n')
fprintf(fid1,'			</LineStyle>\n')
fprintf(fid1,'		</Style>\n')
fprintf(fid1,'		<Style id=''line-A52714-3-highlight''>\n')
fprintf(fid1,'			<LineStyle>\n')
fprintf(fid1,'				<color>ff1427A5</color>\n')
fprintf(fid1,'				<width>5.0</width>\n')
fprintf(fid1,'			</LineStyle>\n')
fprintf(fid1,'		</Style>\n')
fprintf(fid1,'		<StyleMap id=''line-A52714-3''>\n')
fprintf(fid1,'			<Pair>\n')
fprintf(fid1,'				<key>normal</key>\n')
fprintf(fid1,'				<styleUrl>#line-A52714-3-normal</styleUrl>\n')
fprintf(fid1,'			</Pair>\n')
fprintf(fid1,'			<Pair>\n')
fprintf(fid1,'				<key>highlight</key>\n')
fprintf(fid1,'				<styleUrl>#line-A52714-3-highlight</styleUrl>\n')
fprintf(fid1,'			</Pair>\n')
fprintf(fid1,'		</StyleMap>\n')
fprintf(fid1,'	</Document>\n')
fprintf(fid1,'</kml>\n')
fclose(fid1)

clear n lat1 lon1 lat2 lon2 fid1 Sta RxSite ST ans