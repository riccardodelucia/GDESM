%This analysis script is used to plot the microphones configuration tests
%for each test set of one particular simulation. In particular, the
%relative position of equivalent sources, structure plane and hologram
%plane microphones is plotted, along the 3 main 3D planes. This allows
%maximum insight over the setup of each test. Finally, the pressure field
%for the microphones of the current test is showed for the first mode on
%the complete hologram plane.

main;

%% LOAD GEOMETRY AND STRUCTURE DATA
load_geometry_and_structure_data;

%% MAKE OUTPUT FIGURES FOLDER
pathToFigures = fullfile(folder.data, scenario, folder.figures, folder.micSetups);
mkdir(pathToFigures);


%% LOAD EQUIVALENT SOURCES DATA
load(fullfile(folder.data, scenario, file.equivalentSourcesParameters));

%% LOAD ACPR DATA
simulationDataPath = fullfile(folder.data, scenario, folder.boundaryConditions, boundaryConditions);
load(fullfile(simulationDataPath, folder.acousticSimulation, file.acprSpectra));

%% LIST MIC SETUPS
micSetupsPath = fullfile(simulationDataPath,  folder.micSetups);
listing = dir(micSetupsPath);
listing = listing(3:end);

for i=1:length(listing)
    
    micDataFileName = listing(i).name;
    
    load(fullfile(micSetupsPath, micDataFileName));
        
    fprintf(sprintf('Analyzing %s file\n', micDataFileName));
    
    [~,micDataFileName,~] = fileparts(micDataFileName);

    nModesRecords = length(frequencies);
    
    fig1 = figure('visible','off');
    fig2 = figure('visible','off');
    fig3 = figure('visible','off');

    plotCompleteSetup(r_nodes, r_mic, r_q, fig1, fig2, fig3, micDataFileName);
    
    saveas(fig1, fullfile(pathToFigures, sprintf('%s xy view', micDataFileName)), 'png');
    saveas(fig2, fullfile(pathToFigures, sprintf('%s xz view', micDataFileName)), 'png');
    saveas(fig3, fullfile(pathToFigures, sprintf('%s yz view', micDataFileName)), 'png');

    close all;

end