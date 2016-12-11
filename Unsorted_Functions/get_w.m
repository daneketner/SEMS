function w = get_w(ds,scnl,t1,t2)

%GET_W: Quick function for grabbing waveform data from Winston
%
%USAGE: w = get_w(ds,scnl,t1,t2)
%
%INPUTS:  ds
%         scnl
%         t1  - start time
%         t2  - end time

%% INITIALIZE VARIABLES
[t1 t2] = chk_t('num',t1,t2);
if t2<t1
   temp = t1;
   t1 = t2;
   t2 = temp;
end

%% DEAL WITH REQUESTS FOR BIG WAVEFORMS
dur = round((t2-t1)*24*60*60)/(24*60*60);
t_n = floor(dur/0.5);    % Number of full 12 hour blocks
t_r =  rem(dur,0.5);     % Remaining time after last block

try
   if (t_n == 0) || ((t_n == 1)&&(t_r == 0))
      w = waveform(ds,scnl,t1,t2);
   else
      for n = 1:t_n
         tt1 = t1 + .5*(n-1);
         tt2 = t1 + .5*n;
         if n == 1
            w = waveform(ds,scnl,tt1,tt2);
         else
            w = [w; waveform(ds,scnl,tt1,tt2)];
         end
      end
      if t_r > 0
         w = [w; waveform(ds,scnl,tt2,t2)];
      end
   end
   w = combine(w);
catch
   w = waveform;
end







