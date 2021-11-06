%This script is used to import data csv files from comsol FEM analyses.
%Each structure has a Boundary Conditions and Geometry folder. Boundary
%Conditions folder contains specific data for each boundary condition.
%Geometry folder contains structure geometry related data, such as a mesh
%file and a csv file containing the structure normals. Each boundary
%condition FEM folder contains specific files:
% 1) Velocities 2) Eigenfrequencies
%Velocity files contain information about all eigenmodes and parameter
%sets. Therefore it is important to correctly interpret each column,
%assigning it to the correct information within the workspace. Once the
%information is extracted, it is saved in a more convenient '.mat' file to
%be used for offline processing in the following steps of a complete GDESM
%analysis. Therefore, the extraction of FEM data from files has to be done
%only once for each new structure. As GDESM deals with surfaces, we work
%with surface meshes, without taking into account the entire 3D shape of the
%object.

%% IMPORT CONFIGURATION
main;


%% EXTRACT GEOMETRY DATA
%extract both node coordinates and surface normals data. 
[normData] = readFEMNormFile(fullfile(folder.data, scenario, [file.normals '.csv']));

%Please note that r_nodes coming from exported files could not exactly
%coincide with mesh coordinates. An interpolation process over the mesh
%nodes of the desired quantity is mandatory each time we want to plot data
%on meshes. r_nodes will be used for computations, while mesh nodes will
%be used only for plot purposes.
r_nodes = normData{1, 1};
normData = normData{2, 1};
numberOfStructureSurfaceNodes = length(r_nodes);

%% SAVE PROCESSED GEOMETRY DATA
save(fullfile(folder.data, scenario, file.normals), 'normData', '-v7.3');
save(fullfile(folder.data, scenario, file.nodes), 'r_nodes', 'numberOfStructureSurfaceNodes', '-v7.3');

%% EXTRACT DATA FOR EACH BOUNDARY CONDITIONS
listing = dir(fullfile(folder.data, scenario, folder.boundaryConditions));
listing = listing(3:end);

for i=1:length(listing)

    %complete structure file names according to the specific boundary
    %conditions folder name    
    boundaryConditionsPath = fullfile(listing(i).folder, listing(i).name, folder.mechanicSimulation);
    
    %read freq data. Note: for free free boundary conditions, the first six
    %modes correspond to rigid body motions. Here we assume those modes
    %have been carefully filtered out before writing the corresponding csv
    %files.
    [eigenfreqData] = readFEMEigenfreqFile( fullfile(boundaryConditionsPath, [file.eigenfreqs '.csv']), structureParameters.numberOfParameterSets, structureParameters.numberOfFEMModes);
    
    %should vel data be normalized?
    [normVelData] = readFEMVelFile(fullfile(boundaryConditionsPath, [file.normVel '.csv']), structureParameters.numberOfParameterSets, structureParameters.numberOfFEMModes);
        
    %% SAVE DATA
    save(fullfile(boundaryConditionsPath, file.eigenfreqs), 'eigenfreqData', '-v7.3');
    save(fullfile(boundaryConditionsPath, file.normVel), 'normVelData', '-v7.3');

end

