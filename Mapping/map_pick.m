function [id] = map_pick(Master, varargin)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here


if nargin == 1
    ah = gcf;
elseif nargin == 2
    ah = varargin{1};
end

[lon lat] = ginput(ah);

for n = 1:numel(lon)
   [V R] = min(abs(Master.lat - lat) + abs(Master.lon - lon));
   id(n) = Master.evid(R);
end

