%This analysis script plots the shapes of the imported FEM modes. Only the
%first parameter set is considered. It also plots abs vel for all modes and
%all parameter sets. This is useful for understanding differences for same
%indexed modes and fifferent materials.

main;

%% LOAD GEOMETRY AND STRUCTURE DATA
load_geometry_and_structure_data;

%% MAKE OUTPUT FIGURES FOLDER
pathToFigures = fullfile(folder.data, scenario, folder.figures, folder.boundaryConditions, boundaryConditions, folder.mechanicSimulation);
mkdir(pathToFigures);

%% PLOT CHOSEN BOUNDARY CONDITIONS VELOCITIES FOR 1ST PARAMETER SET
%build the path to the chosen boundary conditions folder
structureBoundaryConditionsPath = fullfile(folder.data, scenario, folder.boundaryConditions, boundaryConditions, folder.mechanicSimulation);
        
%load boundary conditions specific files
load(fullfile(structureBoundaryConditionsPath, file.normVel));
load(fullfile(structureBoundaryConditionsPath, file.eigenfreqs));

%export shapes only for the first parameter set
for i = 1:structureParameters.numberOfFEMModes

        fig = figure('visible','off'); 
            plotDataOnMesh(normVelData{1}(: , i), meshVertices, meshFaces, r_nodes);
            freq = eigenfreqData(1, i);
            figureTitle = sprintf('%s mode %d param %d: %d Hz', boundaryConditions, i, 1, round(freq));
            title(figureTitle);
            figureFileTitle = sprintf('%s mode %d', boundaryConditions, i);
            saveas(fig, fullfile(pathToFigures, figureFileTitle), 'png');
            close(fig);
end
