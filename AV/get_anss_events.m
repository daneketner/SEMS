function varargout = get_anss_events(wave)
%
% This program is incomplete
% Extrats all events from ANSS from entire volcano network,
% Future work: keep only events within n miles of a subnet
% Possibly use structured station array, see 'volcano_network.m'
%
%GET_ANSS_EVENTS: Retrieve ANSS events from
%                 ftp://www.ncedc.org/pub/catalogs/anss
%
%INPUTS: wave - (waveform object)
%
%OUTPUTS: events - (waveform objects)

t1  = datevec(get(wave,'start'));  % Start time
t2  = datevec(get(wave,'end'));    % End time
network = get(wave,'network');     % Network
Y_M = [];                          % Vector of Year, Month values (nx2)

if t1(1)==t2(1)
   YYYY = t1(1);
   for MM = t1(2):t2(2)   % All months between t1(2) & t2(2)
      Y_M = [Y_M; YYYY MM];
   end
else                      % More than one year requested
   n_yr = t2(1)-t1(1)+1;  % Number of years requested

   YYYY = t1(1);          % First year
   for MM = t1(2):12      % All months starting t1(2)
      Y_M = [Y_M; YYYY MM];
   end

   if n_yr > 2            % Full intermediate years (i.e. 1997 through 2003,...
      for y = 1:n_yr-1    % This loop handles 1998 through 2002)
         YYYY = YYYY+1;
         for MM = 1:12
            Y_M = [Y_M; YYYY MM];
         end
      end
   end

   YYYY = YYYY+1;        % Last year
   for MM = 1:t2(2)      % All months ending t2(2)
      Y_M = [Y_M; YYYY MM];
   end
end

YYYY = [];
MO = [];
DD = [];
HH = [];
MI = [];
SS = [];
LAT = [];
LON = [];

for n = 1:size(Y_M,1)
   Yr = num2str(Y_M(n,1));
   Mo = num2str(Y_M(n,2));
   Da = '15';
   Date = [Mo, '/', Da, '/', Yr];
   yyyy = datestr(Date,'yyyy');
   mm = datestr(Date,'mm');

   url = java.net.URL(['ftp://www.ncedc.org/pub/catalogs/anss/',yyyy,'/',yyyy,'.',mm,'.cnss']);
   is = openStream(url);
   isr = java.io.InputStreamReader(is);
   br = java.io.BufferedReader(isr);
   s = readLine(br);
   while ~isempty(s)
      s = char(s);
      s = s(1:56);
      C = textscan(s,'%5*s %4n %2n %2n %2n %2n %7.4n %9s %10s %*9s %4s');
      Ntwk = C{1,7}; 
      if strcmpi(strtrim(Ntwk{1,1}),network)==1
         YYYY = [YYYY C{1,1}];
         MO = [MO C{1,2}];
         DD = [DD C{1,3}];
         HH = [HH C{1,4}];
         MI = [MI C{1,5}];
         SS = [SS C{1,6}];
         LAT = [LAT C{1,7}];
         LON = [LON C{1,8}];
      end
      s = readLine(br);
   end
end

varargout{1} = YYYY;
varargout{2} = MO;
varargout{3} = DD;
varargout{4} = HH;
varargout{5} = MI;
varargout{6} = SS;

end % get_anss_events






        
                                                                                         