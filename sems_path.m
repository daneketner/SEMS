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
addpath(genpath('C:\Github\Matlab codes'));

javaaddpath({
    'C:\Github\Winston1.2.12\lib\colt.jar', ...
    'C:\Github\Winston1.2.12\lib\mysql.jar', ...
    'C:\Github\Winston1.2.12\lib\winston-bin.jar', ...
    'C:\Github\IRIS-WS-2.0.15.jar'});

format compact

