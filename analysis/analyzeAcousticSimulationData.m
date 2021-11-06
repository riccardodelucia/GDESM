%This analysis script is used to plot the information about the acoustic
%pressure field and vibration velocities obtained from a COMSOL simulation.
%The acoustic pressure field is represented on the hologram plane. The
%analysis frequencies are plotted as stems on a dedicated figure.

main;

%% LOAD GEOMETRY AND STRUCTURE DATA
load_geometry_and_structure_data;

%% MAKE OUTPUT FIGURES FOLDER
pathToFigures = fullfile(folder.data, scenario, folder.figures, folder.boundaryConditions, boundaryConditions, folder.acousticSimulation);
mkdir(pathToFigures);

%% LOAD SIMULATION DATA
simulationDataPath = fullfile(folder.data, scenario, folder.boundaryConditions, boundaryConditions, folder.acousticSimulation);

%load freq file
load(fullfile(simulationDataPath, file.acprFrequencies));

%load vel file
load(fullfile(simulationDataPath, file.velGroundtruth));

%load acpr file
load(fullfile(simulationDataPath, file.acprSpectra));

%% PLOT ACOUSTIC SPECTRA AND GROUNDTRUTH VELOCITY
for i=1:length(acpr_frequencies)
    fig = figure('visible', 'off');
    figureTitle = sprintf('mode %d - %d Hz', i, acpr_frequencies(i));
    disp(figureTitle);

    title(figureTitle);

    subplot(121);
    plotFieldOnScatteredPoints(acpr_r_holo, acpr_spectra(:, i));
    title(sprintf('Hologram plane %f m', acpr_r_holo(1, 3)));
    subplot(122);
    plotDataOnMesh(vel_groundtruth(:, i), meshVertices, meshFaces, r_vel_groundtruth);
    
    saveas(fig, fullfile(pathToFigures, figureTitle), 'png');
    
    close(fig);
end

%% PLOT FREQUENCIES
fig = figure;%('visible', 'off');
stem(acpr_frequencies, ones(length(acpr_frequencies), 1));
xlabel('Hz');
figureTitle = 'acoustic simulation frequencies';
figureFileTitle= figureTitle;
title(figureTitle);
saveas(fig, fullfile(pathToFigures, figureFileTitle), 'png');

close(fig);