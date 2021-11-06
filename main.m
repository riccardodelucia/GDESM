clear all;
close all;
clc;

%% IMPORT ALL GDESM FOLDERS
root = fileparts(which(mfilename));
addpath(genpath(root));

%% VARIABLES
setup_files_and_folders_names;
setup_other_parameters;

%% FILES AND PATHS
scenario = 'GUITAR_eqsrcsINSIDE';


%% READ CONFIG FILE PARAMETERS
ini = IniConfig();

ini.ReadFile(fullfile(folder.data, scenario, file.config));
sections = ini.GetSections();


%% SETUP STRUCTURE PARAMETERS
[keys, ~] = ini.GetKeys(sections{1});
values = ini.GetValues(sections{1}, keys);

structureParameters.numberOfFEMModes = values{1};
structureParameters.numberOfParameterSets = values{2};

%% SETUP EQUIVALENT SOURCES
[keys, ~] = ini.GetKeys(sections{2});
values = ini.GetValues(sections{2}, keys);

eqSourcesParameters.z_q = values{1}; % m
eqSourcesParameters.QPlaneWidth = values{2}; % m
eqSourcesParameters.QPlaneHeight = values{3}; % m
eqSourcesParameters.QDiscretizationStepX = values{4}; %m
eqSourcesParameters.QDiscretizationStepY = values{5}; %m
eqSourcesParameters.trimEquivalentSourcesPlane = strcmpi(values{6}, 'true');

%% SETUP ACOUSTIC SIMULATION PARAMETERS
[keys, ~] = ini.GetKeys(sections{3});
values = ini.GetValues(sections{3}, keys);

boundaryConditions = values{1}; 
  
%% CREATE FOLDERS
mkdir(fullfile(folder.data, scenario, folder.figures));

addpath(genpath(root));

