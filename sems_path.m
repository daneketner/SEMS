function sems_path

%SEMS_PATH: Sets path for m-files used by 'sems_gui' and 'sems_program'
%
%INPUTS: none
%
%OUTPUTS: none

% Author: Dane Ketner, Alaska Volcano Observatory
% $Date$
% $Revision$

addpath(genpath('C:\Github\GISMO-1'));
addpath(genpath('C:\Github\SEMS'));



javaaddpath({
    'C:\Winston1.1\lib\colt.jar', ...
    'C:\Winston1.1\lib\mysql.jar', ...
    'C:\Winston1.1\lib\winston-bin.jar'});

format compact
try
    cd('C:\AVO\SEMS_SVN\SEMS')
catch
    cd('C:\AVO\SEMS')
end
