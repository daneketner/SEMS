function sems_path

%SEMS_PATH: Sets path for SEMS
%
%INPUTS: none
%
%OUTPUTS: none

% Author: Dane Ketner, Alaska Volcano Observatory
% Date: 12/10/2016
% Revision: 201

addpath(genpath('C:\Github\GISMO-1'));
addpath(genpath('C:\Github\SEMS'));

javaaddpath({
    'C:\Github\Winston1.2\lib\colt.jar', ...
    'C:\Github\Winston1.2\lib\mysql.jar', ...
    'C:\Github\Winston1.2\lib\winston-bin.jar'});

format compact

