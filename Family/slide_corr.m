function w_cc = slide_corr(w_big,w_small)
%
%SLIDE_CORR: Return waveform object (w_cc) resulting from a correlation of 
%            waveform (w_small), with all possible windows of length 
%   w_small in waveform (w_big). This can be viwed as sliding w_small 
%   through w_big and correlating at all window positions. The resulting 
%   waveform: w_cc, is w_big with data replaced with correlation
%   coefficients (cc). cc values are stored at the first point (leftmost) 
%   in each correlation window. This means the last values (rightmost)in 
%   w_cc of length(w_small) will all equal 0.
%
%USAGE: w_cc = slide_corr(w_big,w_small)
%
%INPUTS: w_big - waveform over which to scan for correlation values
%        w_small - seed waveform, correlates to all windows within w_big
%
%OUTPUTS: w_cc - Output waveform, w_big with data replaced with cc.

d_small = get(w_small,'data');    % Small data window
d_big = get(w_big,'data');        % Big data window
cc = d_big*0;                     % Initialize to all 0 values

% --- Next 4 lines can be commented if no progress bar is desired
wb_h = waitbar(0);                   % waitbar handle
sta = get(w_big,'station');          % Used only by waitbar
cha = get(w_big,'channel');          % Used only by waitbar
start = datestr(get(w_big,'start')); % Used only by waitbar
% ---

for k = 1:length(d_big)-length(d_small); % Number of slide increments
   win = d_big(k:k+length(d_small)-1);   % Slide the window
   corr = corrcoef(win,d_small);         % Result is 2x2...
   cc(k) = corr(1,2);                    % but we only want 1 number                     
   % --- Progress bar feedback
   waitbar(k/(length(d_big)-length(d_small)),wb_h,...
   ['Searching for events in ',sta,':',cha,' - ',start])
   % ---
end
% --- Kill progress bar
delete(wb_h)
% ---
w_cc = set(w_big,'data',cc); % Make output waveform
