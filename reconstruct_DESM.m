setup_reconstruction;

%% RECONSTRUCT STRUCTURE VELOCITIES
reconstructionFolder = fullfile(simulationDataPath, folder.reconstruction, folder.DESM);
mkdir(reconstructionFolder);

for f=1:length(fileNameList)
    
    micDataFileName = char(fileNameList(f));  

    load(fullfile(micSetupsPath, micDataFileName));
    
    [filepath, micDataFileName, ext] = fileparts(micDataFileName); 
    
    fprintf(sprintf('Computing results for %s\n', micDataFileName));
    
    %% DESM RECONSTRUCTION PHASE

    [reconstructedVelocities] = DESM(frequencies, micSpectra, D_by_bc, D_frequencies_by_bc, r_mic, r_nodes, r_q, normData, physicsParameters);
    
    resultsFolder = fullfile(simulationDataPath, folder.reconstruction, folder.DESM, micDataFileName);
    mkdir(resultsFolder);

    save(fullfile(resultsFolder, file.results), 'reconstructedVelocities', 'frequencies', '-v7.3');

end