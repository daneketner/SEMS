
%% MAKE ANALOG TELEMETRY KML FILE

ST = fieldnames(ANA);
fid1 = fopen('C:\AVO\Github\SEMS\AV\analogTelemetry.kml','w+');

fprintf(fid1,'<?xml version=''1.0'' encoding=''UTF-8''?>\n')
fprintf(fid1,'<kml xmlns=''http://www.opengis.net/kml/2.2''>\n')
fprintf(fid1,'	<Document>\n')
fprintf(fid1,'		<name>Analog Telemetry</name>\n')

for n = 1:numel(ST)
    Sta = ST{n};
    
    lat1 = ANA.(Sta).LatitudeWG84;
    lon1 = ANA.(Sta).LongitudeWG84;
    RxSite =  ANA.(Sta).RxSiteCode;
    switch lower(RxSite(end-2:end))
        case{'_rx'}
            lat2 = RX.(RxSite).LatitudeWG84;
            lon2 = RX.(RxSite).LongitudeWG84;
        case{'rep'}
            if strcmp(RxSite(end-3),'_')
                lat2 = REP.(RxSite).LatitudeWG84;
                lon2 = REP.(RxSite).LongitudeWG84;
            else
                lat2 = ANA.(RxSite).LatitudeWG84;
                lon2 = ANA.(RxSite).LongitudeWG84;
            end
        otherwise
            lat2 = ANA.(RxSite).LatitudeWG84;
            lon2 = ANA.(RxSite).LongitudeWG84;
    end
    lat1 = num2str(lat1);
    lon1 = num2str(lon1);
    lat2 = num2str(lat2);
    lon2 = num2str(lon2);

    fprintf(fid1,['		<Placemark>\n'])
    fprintf(fid1,['			<name>',Sta,' to ',RxSite,'</name>\n'])
%    fprintf(fid1,['			<description><![CDATA['...
%                                    'Frequency (MHz): ',num2str(ANA.(Sta).FreqMHz),'<br>'...
%                                           'Polarity: ',ANA.(Sta).Polarity,'<br>'...
%                                   'Distance (miles): ',num2str(ANA.(Sta).DistanceMiles),'<br>'...
%                                            'Azimuth: ',num2str(ANA.(Sta).Azimuth),'<br>'...
%                                  'Telemetry Diagram: ',ANA.(Sta).TelemDiagURL,'<br>'...
%                       ']]></description>\n'])
    fprintf(fid1,['			<styleUrl>#line-A52714-3</styleUrl>\n'])
    fprintf(fid1,['			<ExtendedData>\n'])
    fprintf(fid1,['				<Data name=''Frequency (MHz)''>\n'])
    fprintf(fid1,['					<value>',num2str(ANA.(Sta).FreqMHz),'</value>\n'])
    fprintf(fid1,['				</Data>\n'])
    fprintf(fid1,['				<Data name=''Polarity''>\n'])
    fprintf(fid1,['					<value>',ANA.(Sta).Polarity,'</value>\n'])
    fprintf(fid1,['				</Data>\n'])
    fprintf(fid1,['				<Data name=''Distance (miles)''>\n'])
    fprintf(fid1,['					<value>',num2str(ANA.(Sta).DistanceMiles),'</value>\n'])
    fprintf(fid1,['				</Data>\n'])
    fprintf(fid1,['				<Data name=''Azimuth''>\n'])
    fprintf(fid1,['					<value>',num2str(ANA.(Sta).Azimuth),'</value>\n'])
    fprintf(fid1,['				</Data>\n'])
    fprintf(fid1,['				<Data name=''Telemetry Diagram''>\n'])
    fprintf(fid1,['					<value>',ANA.(Sta).TelemDiagURL,'</value>\n'])
    fprintf(fid1,['				</Data>\n'])
    fprintf(fid1,['			</ExtendedData>\n'])
    fprintf(fid1,['			<LineString>\n'])
    fprintf(fid1,['				<tessellate>1</tessellate>\n'])
    fprintf(fid1,['				<coordinates>',lon1,',',lat1,',0.0 ',lon2,',',lat2,',0.0</coordinates>\n'])
    fprintf(fid1,['			</LineString>\n'])
    fprintf(fid1,['		</Placemark>\n'])
    fprintf(fid1,'\n')
    
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