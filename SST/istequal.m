function bool = istequal(t1,t2)
%
%ISTEQUAL: Compare 2 Matlab time values for equality
%
%USAGE: bool = istequal(t1,t2)
%
%INPUTS: t1,t2 - Matlab formatted date numbers
%
%OUTPUTS: bool - 1 or 0

t1 = round(t1*24*60*60*1000); % Units: seconds/1000
t2 = round(t2*24*60*60*1000); % Units: seconds/1000
bool = isequal(t1,t2);