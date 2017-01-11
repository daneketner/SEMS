function dateUTC = local2UTC(dateLocal)

if isnumeric(dateLocal) && (dateLocal(1) > datenum(1900,1,1))
    type = 'num';
elseif isnumeric(dateLocal) && (size(dateLocal,2) == 6) && (dateLocal(1,1) < 2600)
    type = 'vec';
elseif ischar(dateLocal) || iscell(dateLocal)
    type = 'str';
end

dateLocal = datenum(dateLocal);
dateVectorLocal = datevec(dateLocal);
nDates = size(dateVectorLocal,1) ;
dateVectorUTC = zeros(nDates,6) ;

% import the Java classes needed for this process

import java.text.SimpleDateFormat ;
import java.util.Date ;
import java.util.TimeZone ;

% instantiate a SimpleDateFormat object with a fixed time/date format and UTC time zone

utcFormatObject = SimpleDateFormat('yyyy-MM-dd HH:mm:ss') ;
utcFormatObject.setTimeZone(TimeZone.getTimeZone('UTC')) ;

% loop over date strings

for iDate = 1:nDates
    
    dateVec = dateVectorLocal(iDate,:) ;
    
    %     instantiate a Java Date class object with the local time.  Note that Java year is
    %     year since 1900, and Java month is zero-based
    
    localDateObject = Date(dateVec(1)-1900, dateVec(2)-1, dateVec(3), ...
        dateVec(4), dateVec(5), dateVec(6)) ;
    
    %     convert the date object to a string in the correct format and in UTC
    
    dateStringUTC = char(utcFormatObject.format(localDateObject)) ;
    
    %     pick through the resulting string and extract the data we want, converting to
    %     numbers as we go
    
    dateVectorUTC(iDate,1) = str2num(dateStringUTC(1:4)) ;
    dateVectorUTC(iDate,2) = str2num(dateStringUTC(6:7)) ;
    dateVectorUTC(iDate,3) = str2num(dateStringUTC(9:10)) ;
    dateVectorUTC(iDate,4) = str2num(dateStringUTC(12:13)) ;
    dateVectorUTC(iDate,5) = str2num(dateStringUTC(15:16)) ;
    dateVectorUTC(iDate,6) = str2num(dateStringUTC(18:19)) ;
    
end % loop over dates

switch type
    case 'num'
        dateUTC = datenum(dateVectorUTC);
    case 'str'
        dateUTC = datestr(dateVectorUTC);
    otherwise
        dateUTC = dateVectorUTC;
end

return

