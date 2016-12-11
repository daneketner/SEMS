% Experiment 1
% Take broadband data from BHE,BHN, and BHZ (Same time window)
% Demean all, take abs, then add all together
% Low pass resulting vector below .1 Hz
% Take the average of resulting vector
% Scan the vector for event times (greater than scale*mean)
% Which last longer than __

% Results:

host = 'avovalve01.wr.usgs.gov';
port = 16022;
ds = datasource('winston',host,port);
% station = 'RDWB';
% channel = {'BHZ','BHN','BHE'};
station = {'RSO'};
channel = {'EHZ','EHN','BHE'};
network = 'AV';
scnl = scnlobject(station,channel,network);
t_start = [2009 03 12 00 00 00];
t_end = [2009 03 12 06 00 00];
t1 = datestr(t_start,0);
t2 = datestr(t_end,0);
w = waveform(ds,scnl,t1,t2);
w1 = w(1);
w = bb_filt(w);
w = stack(abs(demean(w)));
lp = filterobject('L',.1,2);      
w = filtfilt(lp,w);  
m = mean(w);
data = get(w,'data');
tv = get(w,'timevector');
e_sst = [];
trig = 0;
count = 0;
en = 0;
for n=1:length(data)
   if data(n)>2*m % Above thresh
      count = count+1;
      if trig == 0
         trig = 1; 
         t_on = tv(n); 
      end
   else % Below thresh
      if trig == 1
         if count > 100
            t_off = tv(n);
            en = en+1;
            e_sst(en,:) = [t_on t_off];
            t_on = []; t_off = [];
            count = 0;
            trig = 0;
         else
         t_on = []; t_off = [];  
         count = 0;
         trig = 0;
         end
      end
   end
end

helicorder(w1,10,e_sst)


