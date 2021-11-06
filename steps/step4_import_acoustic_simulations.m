%This script is used to import acoustic field simulation data from csv
%files provided by COMSOL. The data is processed and collected in '.mat'
%structures, which will be used to store groundtruth velocities and to
%compute undersampled microphones setups.

main;


%% EXTRACT DATA FOR EACH BOUNDARY CONDITIONS
listing = dir(fullfile(folder.data, scenario, folder.boundaryConditions));
listing = listing(3:end);

for i=1:length(listing)
    
    simulationDataPath = fullfile(listing(i).folder, listing(i).name, folder.acousticSimulation);
    
    %read freq csv file
    acpr_frequencies = csvread(fullfile(simulationDataPath, [file.acprFrequencies, '.csv']));
    
    %read vel csv file
    
    vel_groundtruth = csvread(fullfile(simulationDataPath, [file.velGroundtruth, '.csv']));
    r_vel_groundtruth = vel_groundtruth(:, 1:3);
    vel_groundtruth = vel_groundtruth(:, 4:end);
    
    %read acpr spectra csv file
    acpr_spectra = csvread(fullfile(simulationDataPath, [file.acprSpectra '.csv']));
    %TODO: trim acpr plane according to the grid
    acpr_r_holo = acpr_spectra(:, 1:3);
    acpr_spectra = acpr_spectra(:, 4:end);
    
    %acpr_size is measured in meters
    acpr_size = [max(acpr_r_holo(:, 1))-min(acpr_r_holo(:, 1)) max(acpr_r_holo(:, 2))-min(acpr_r_holo(:, 2))];
    
    %number of acpr samples along X and Y axes
    acpr_axes_n_samples = [length(unique(acpr_r_holo(:, 1))) length(unique(acpr_r_holo(:, 2)))];
    
    save(fullfile(simulationDataPath, file.acprFrequencies), 'acpr_frequencies', '-v7.3');
    save(fullfile(simulationDataPath, file.acprSpectra), 'acpr_r_holo', 'acpr_spectra', 'acpr_size', 'acpr_axes_n_samples', '-v7.3');
    save(fullfile(simulationDataPath, file.velGroundtruth), 'vel_groundtruth', 'r_vel_groundtruth', '-v7.3');
    
end