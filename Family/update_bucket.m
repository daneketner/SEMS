function [b,new_fam] = update_bucket(in_wfa,b,msf)
%
% The term 'event' is used here to refer to a waveform object that resides
% inside of the bucket until a sufficient number of events correlate above
% some threshold.
%
% b      - Bucket, storage place for waveforms looking for a family
% b.wfa  - Waveform array of all events in bucket
% b.cc   - Correlation Coeffiecient matrix of all events in bucket
% b.ri   - Cell Array containing Index of event relatives
%           (i.e.--->  b.ri{3} = [19 73 123] 
%            event number 3 correlates to 19, 73, and 123 above b.fct)
% b.fct  - Family Correlation Threshold (between 0 and 1) ---> try 0.8
% b.maxt - Maximum span of time before events are removed from bucket
%           (Decimal days - .5 will retain events in b for 12 hours)
% b.maxn - Maximum number of events allowed in bucket (integer value)

if ~isa(in_wfa,'waveform')
   error('Error in update_bucket --> in_wfa is not type: waveform')
end

if isempty(b)
   error('Error in update_bucket --> b must be initialized first')
else
   n = numel(in_wfa);          % Number of new waveforms entering b
   N = numel(b.wfa);           % Number of waveforms before new set
   temp_cc = zeros(N+n,N+n);   % Grow cc square to fit new wf members
   temp_cc(1:N,1:N) = b.cc;    % Add existing cc values
   b.cc = temp_cc;             % replace original
   clear temp_cc
   b.wfa = [b.wfa, in_wfa];    % Grow Waveform Array
   b.ri = [b.ri cell(1,n)];    % Grow Relatives Index Cell Array

   for kk = 1:n                % 1:number of new waveforms
      d = get(b.wfa(kk+N),'data'); 
      if kk+N > b.maxn          % Delete first event in b if the max 
         b = delete_event(b,1); % number of events is exceeded
         N = N-1;
      end
      if (get(b.wfa(kk+N),'start')-get(b.wfa(1),'start')) > b.maxt
         b = delete_event(b,1);
         N = N-1;
      end
      for KK = 1:kk+N-1  % 1:number of cc rows or columns currently filled
         D = get(b.wfa(KK),'data');
         temp = corrcoef(d,D);    % Result is 2x2...
         temp = temp(1,2);        % but we only want 1 number 
         b.cc(kk+N,KK) = temp;    % fill in value on both sides...
         b.cc(KK,kk+N) = temp;    % of matrix diagonal
         if temp > b.fct          % is new value above threshold?
            b.ri{KK} = [b.ri{KK}, kk+N];   % Cross-index both relatives
            b.ri{kk+N} = [b.ri{kk+N}, KK]; 
         end
      end
      b. cc(kk+KK,kk+KK)=1; % Diagonal: self correlation = 1
   end
end
imagesc(new_cc)

function b = delete_event(b,e_n) 
% e_n is event number of event to be deleted from b
b.wfa(e_n) = [];  % Remove waveform
b.cc(e_n,:) = []; % Remove column and row from cc
b.cc(:,e_n) = []; % 
e_ri = b.ri{e_n}; % Store Relative Index in e_ri
for m = 1:numel(e_ri)
   del_ind = find(b.ri{e_ri(m)}==e_n); % Find other events which may...
   if del_ind > 0                      % reference event e_n and...
      b.ri{e_ri(m)}(del_ind)=[];       % remove those references      
   end
end
b.ri(e_n) = []; % delete ri entry
% Because event e_n is deleted, all events following it are decremented,
% Thus any reference to events greater than e_n must also be decremented
for m = 1:numel(b.ri)
   b.ri{m}=b.ri{m}-(b.ri{m}>e_n)
end

function [fam,b] = extract_fam(b,e_n)
ind = [e_n, b.ri{e_n}]; % index event e_n and all relatives of event e_n
fam = b.wfa(ind);       % collect family
for m = 1:numel(ind)
   b = delete()
end