%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   
%   Function - Display Envelopes
%
%   Displays input data (in_data) with an upper and lower
%   cubic spline fit envelope and a mean envelope (upper+lower)/2.
%   
%   Outputs:
%       
%       envlp - 3 x n matrix containing envelopes
%       envlp(:,1) - values of upper envelope (size of in_data)
%       envlp(:,2) - values of lower envelope (size of in_data)   
%       envlp(:,3) - values of mean envelope (size of in_data)
%       data - in_data with offset removed
%   
%   Written by Dane Ketner - University of Alaska Anchorage
%   4/20/2010
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [envlp, data]= disp_env(in_data)

x=in_data;
s=max(length(x));
x=x-sum(x)/s;
xx=1:1:s;
[spmax, spmin, flag]= extrema(x);
ucs = csapi(spmax(:,1),spmax(:,2),xx);
lcs = csapi(spmin(:,1),spmin(:,2),xx);
mcs = (ucs+lcs)/2;

data = x;
envlp(:,1)=ucs;
envlp(:,2)=lcs;
envlp(:,3)=mcs;

figure
plot(x); 
xlim([1 s]) 
hold on
plot(ucs,'r','LineWidth',2); 
plot(mcs,'r:','LineWidth',3);
plot(lcs,'r','LineWidth',2); 
legend('data','upper envelope','mean envelope','lower envelope') 
hold off







