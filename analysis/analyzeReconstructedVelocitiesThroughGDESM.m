%This analysis script is used to assert the reconstruction quality of a set
%of mechanical velocities after a GDESM procedure. The reconstructed
%velocities are compared with the groundtruth velocities computed in the
%simulation for the acoustic pressure field used as input in the GDESM
%procedure. Groundtruth and reconstructed velocities are compared through a
%correlation index. The behavior of the correlation along the reconstructed
%frequencies is finally collected in a figure.

main;

%% LOAD GEOMETRY AND STRUCTURE DATA
load_geometry_and_structure_data;

%% MAKE OUTPUT FIGURES FOLDER
pathToFigures = fullfile(folder.data, scenario, folder.figures, folder.boundaryConditions, boundaryConditions, folder.reconstruction, folder.GDESM);
mkdir(pathToFigures);

%% SETUP PATHS
pathToReconstruction = fullfile(folder.data, scenario, folder.boundaryConditions, boundaryConditions, folder.reconstruction, folder.GDESM);
pathToAcousticSimulation = fullfile(folder.data, scenario, folder.boundaryConditions, boundaryConditions, folder.acousticSimulation);

analyzeReconstructedVelocities;

