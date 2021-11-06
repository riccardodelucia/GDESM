%This is the core script of the entire NAH GDESM problem. It allows to
%reconstruct the surface velocity of a vibrating structure given one mic
%test set and one dictionary.

setup_reconstruction;

%% RECONSTRUCT STRUCTURE VELOCITIES
reconstructionFolder = fullfile(simulationDataPath, folder.reconstruction, folder.GDESM);
mkdir(reconstructionFolder);

for f=1:length(fileNameList)
    
    micDataFileName = char(fileNameList(f));  

    load(fullfile(micSetupsPath, micDataFileName));
    
    [filepath, micDataFileName, ext] = fileparts(micDataFileName); 
    
    fprintf(sprintf('Computing results for %s\n', micDataFileName));

    %nModesRecords = length(frequencies);
    
    %% GDESM RECONSTRUCTION PHASE

    [reconstructedVelocities] = GDESM(frequencies, micSpectra, D_by_bc, D_frequencies_by_bc, r_mic, r_nodes, r_q, normData, physicsParameters, lambda);
    
    %reconstructionFileName = ['GDESM ', erase(micDataFileName, ' setup')];
    
    resultsFolder = fullfile(simulationDataPath, folder.reconstruction, folder.GDESM, micDataFileName);
    mkdir(resultsFolder);

    save(fullfile(resultsFolder, file.results), 'reconstructedVelocities', 'frequencies', '-v7.3');

end