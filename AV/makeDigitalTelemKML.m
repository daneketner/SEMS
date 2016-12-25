
%% MAKE DIGITAL TELEMETRY KML FILE

SiteCodes = fieldnames(RAD);
fid1 = fopen('C:\Github\SEMS\AV\digitalTelemetry.kml','w+');

fprintf(fid1,'<?xml version=''1.0'' encoding=''UTF-8''?>\n');
fprintf(fid1,'<kml xmlns=''http://www.opengis.net/kml/2.2''>\n');
fprintf(fid1,'	<Document>\n');
fprintf(fid1,'		<name>Digital Telemetry</name>\n');

for n = 1:numel(SiteCodes)
    try
        SiteCode = SiteCodes{n};
        switch lower(SiteCode(end-2:end))
            case{'_rx'}
                SiteStruct = RX.(SiteCode);
            case{'rep'}
                if strcmp(SiteCode(end-3),'_')
                    SiteStruct = REP.(SiteCode);
                else
                    SiteStruct = DIG.(SiteCode);
                end
            otherwise
                SiteStruct = DIG.(SiteCode);
        end
        lat1 = num2str(SiteStruct.LatitudeWG84);
        lon1 = num2str(SiteStruct.LongitudeWG84);
        RadioCodes = fieldnames(RAD.(SiteCode));
        for m = 1:numel(RadioCodes)
            RadioStruct = RAD.(SiteCode).(RadioCodes{m});
            if ~isempty(RadioStruct.RxRadioCode)
                RxRadioCode = RadioStruct.RxRadioCode(end-1:end);
                RxSiteCode = RadioStruct.RxRadioCode(1:end-3);
                RxRadioStruct = RAD.(RxSiteCode).(RxRadioCode);
                switch lower(RxSiteCode(end-2:end))
                    case{'_rx'}
                        RxSiteStruct = RX.(RxSiteCode);
                    case{'rep'}
                        if strcmp(RxSiteCode(end-3),'_')
                            RxSiteStruct = REP.(RxSiteCode);
                        else
                            RxSiteStruct = DIG.(RxSiteCode);
                        end
                    otherwise
                        RxSiteStruct = DIG.(RxSiteCode);
                end
                lat2 = num2str(RxSiteStruct.LatitudeWG84);
                lon2 = num2str(RxSiteStruct.LongitudeWG84);
                
                fprintf(fid1,['		<Placemark>\n']);
                fprintf(fid1,['			<name>',SiteCode,' to ',RxSiteCode,'</name>\n']);
                
                fprintf(fid1,['			<styleUrl>#line-A52714-3</styleUrl>\n']);
                fprintf(fid1,['			<ExtendedData>\n']);
                fprintf(fid1,['				<Data name=''Distance (Miles)''>\n']);
                fprintf(fid1,['					<value>',num2str(SiteStruct.DistanceMiles),'</value>\n']);
                fprintf(fid1,['				</Data>\n']);
                fprintf(fid1,['				<Data name=''Azimuth''>\n']);
                fprintf(fid1,['					<value>',num2str(SiteStruct.Azimuth),'</value>\n']);
                fprintf(fid1,['				</Data>\n']);
                fprintf(fid1,['				<Data name=''Polarity (miles)''>\n']);
                fprintf(fid1,['					<value>',RadioStruct.Polarity,'</value>\n']);
                fprintf(fid1,['				</Data>\n']);
                fprintf(fid1,['				<Data name=''P-P of P-MP''>\n']);
                fprintf(fid1,['					<value>',RadioStruct.PPPMP,'</value>\n']);
                fprintf(fid1,['				</Data>\n']);
                fprintf(fid1,['				<Data name=''Frequency Key''>\n']);
                fprintf(fid1,['					<value>',RadioStruct.FKey,'</value>\n']);
                fprintf(fid1,['				</Data>\n']);
                fprintf(fid1,['				<Data name=''Network ID''>\n']);
                fprintf(fid1,['					<value>',num2str(RadioStruct.NetID),'</value>\n']);
                fprintf(fid1,['				</Data>\n']);
                fprintf(fid1,['				<Data name=''TX RADIO''>\n']);
                fprintf(fid1,['					<value>',[RadioStruct.Model,' S/N ', num2str(RadioStruct.SN)],'</value>\n']);
                fprintf(fid1,['				</Data>\n']);
                fprintf(fid1,['				<Data name=''Tx Radio IP Address''>\n']);
                fprintf(fid1,['					<value>',[RadioStruct.IPAddress,' : ',num2str(RadioStruct.Port)],'</value>\n']);
                fprintf(fid1,['				</Data>\n']);
                fprintf(fid1,['				<Data name=''Tx Radio Type (E or R)''>\n']);
                fprintf(fid1,['					<value>',RadioStruct.TYPE,'</value>\n']);
                fprintf(fid1,['				</Data>\n']);
                fprintf(fid1,['				<Data name=''Tx Radio Subnet (Rx/Tx)''>\n']);
                fprintf(fid1,['					<value>',RadioStruct.SNRxTx,'</value>\n']);
                fprintf(fid1,['				</Data>\n']);
                fprintf(fid1,['				<Data name=''RX RADIO''>\n']);
                fprintf(fid1,['					<value>',[RxRadioStruct.Model,' S/N ', num2str(RxRadioStruct.SN)],'</value>\n']);
                fprintf(fid1,['				</Data>\n']);
                fprintf(fid1,['				<Data name=''Rx Radio IP Address''>\n']);
                fprintf(fid1,['					<value>',[RxRadioStruct.IPAddress,' : ',num2str(RxRadioStruct.Port)],'</value>\n']);
                fprintf(fid1,['				</Data>\n']);
                fprintf(fid1,['				<Data name=''Rx Radio Type (E or R)''>\n']);
                fprintf(fid1,['					<value>',RxRadioStruct.TYPE,'</value>\n']);
                fprintf(fid1,['				</Data>\n']);
                fprintf(fid1,['				<Data name=''Rx Radio Subnet (Rx/Tx)''>\n']);
                fprintf(fid1,['					<value>',RxRadioStruct.SNRxTx,'</value>\n']);
                fprintf(fid1,['				</Data>\n']);
                fprintf(fid1,['			</ExtendedData>\n']);
                fprintf(fid1,['			<LineString>\n']);
                fprintf(fid1,['				<tessellate>1</tessellate>\n']);
                fprintf(fid1,['				<coordinates>',lon1,',',lat1,',0.0 ',lon2,',',lat2,',0.0</coordinates>\n']);
                fprintf(fid1,['			</LineString>\n']);
                fprintf(fid1,['		</Placemark>\n']);
                fprintf(fid1,'\n');
                
            end
        end
    catch
    end
end

fprintf(fid1,'		<Style id=''line-A52714-3-normal''>\n');
fprintf(fid1,'			<LineStyle>\n');
fprintf(fid1,'				<color>ff1427A5</color>\n');
fprintf(fid1,'				<width>3</width>\n');
fprintf(fid1,'			</LineStyle>\n');
fprintf(fid1,'		</Style>\n');
fprintf(fid1,'		<Style id=''line-A52714-3-highlight''>\n');
fprintf(fid1,'			<LineStyle>\n');
fprintf(fid1,'				<color>ff1427A5</color>\n');
fprintf(fid1,'				<width>5.0</width>\n');
fprintf(fid1,'			</LineStyle>\n');
fprintf(fid1,'		</Style>\n');
fprintf(fid1,'		<StyleMap id=''line-A52714-3''>\n');
fprintf(fid1,'			<Pair>\n');
fprintf(fid1,'				<key>normal</key>\n');
fprintf(fid1,'				<styleUrl>#line-A52714-3-normal</styleUrl>\n');
fprintf(fid1,'			</Pair>\n');
fprintf(fid1,'			<Pair>\n');
fprintf(fid1,'				<key>highlight</key>\n');
fprintf(fid1,'				<styleUrl>#line-A52714-3-highlight</styleUrl>\n');
fprintf(fid1,'			</Pair>\n');
fprintf(fid1,'		</StyleMap>\n');
fprintf(fid1,'	</Document>\n');
fprintf(fid1,'</kml>\n');
fclose(fid1)

clear n m lat1 lon1 lat2 lon2 fid1 SiteStruct RadioCodes RadioStruct...
    RxRadioCode RxRadioStruct RxSiteCode RxSiteStruct SiteCode SiteCodes ans