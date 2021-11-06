%This is the core script of the entire NAH GDESM problem. It allows to
%reconstruct the surface velocity of a vibrating structure given one mic
%test set and one dictionary.

setup_reconstruction;

%% RECONSTRUCT STRUCTURE VELOCITIES
reconstructionFolder = fullfile(simulationDataPath, folder.reconstruction, folder.ESM);
mkdir(reconstructionFolder);

for f=1:length(fileNameList)
    
    micDataFileName = char(fileNameList(f));  

    load(fullfile(micSetupsPath, micDataFileName));
    
    [filepath, micDataFileName, ext] = fileparts(micDataFileName); 
    
    fprintf(sprintf('Computing results for %s\n', micDataFileName));
    
    %% ESM
    [reconstructedVelocities] =  ESM(frequencies, micSpectra, r_mic, r_nodes, r_q, normData, physicsParameters);
    
    resultsFolder = fullfile(simulationDataPath, folder.reconstruction, folder.ESM, micDataFileName);
    mkdir(resultsFolder);

    save(fullfile(resultsFolder, file.results), 'reconstructedVelocities', 'frequencies', '-v7.3');

end