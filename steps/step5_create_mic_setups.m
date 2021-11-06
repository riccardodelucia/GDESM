%This script is used to extract microphone tests sets from simulated
%acoustic pressure fields. The complete acoustic pressure field consists of
%a dense set of points which accurately sample the hologram plane.
%Microphone sets are extracted by taking only some of these points, in
%order to test several acoustic pressure field undersampled configurations.
%In order to maintain the baffle conditions , microphones are chosen to be
%within the structure boundaries. This is is due also to the fact that we
%use very few microphones. It would be a waste to put some of them in
%places other than above the acoustic surface.

main;

%% LOAD GEOMETRY AND STRUCTURE DATA
load_geometry_and_structure_data;

%% LOAD EQUIVALENT SOURCES DATA
load(fullfile(folder.data, scenario, file.equivalentSourcesParameters))

%% EXTRACT DATA FOR EACH BOUNDARY CONDITIONS
listing = dir(fullfile(folder.data, scenario, folder.boundaryConditions));
listing = listing(3:end);

for i=1:length(listing)
    simulationDataPath = fullfile(listing(i).folder, listing(i).name);   
    load(fullfile(simulationDataPath, folder.acousticSimulation, file.acprFrequencies));
    
    load(fullfile(simulationDataPath, folder.acousticSimulation, file.acprSpectra));
    frequencies = acpr_frequencies;
    
    %% MAKE MIC DIRECTORY
    micSetupsPath = fullfile(simulationDataPath, folder.micSetups);
    mkdir(micSetupsPath);
    
    
    %% DEFINE NOISE LEVELS
    noise_snr = [15 10 5];
    
    %% EXTRACTING AN INTERNAL SUBGRID WITH MICS CONTAINED WITHIN THE BOUNDING BOX
    [acpr_r_holo, acpr_spectra, acpr_axes_n_samples, acpr_boundary_coordinates] = extractAcprWithinStructureBoundingBox(acpr_r_holo, r_nodes, acpr_spectra);
    
    %% 32 MICS RANDOM GRID
    micTestSetupInfo.nMics = 32;
    fileName = '32 mics random setup';
    
    [r_mic, micSpectra] = subSampleRandomMicGrid(acpr_r_holo, acpr_spectra, 32);
    
    save(fullfile(micSetupsPath, fileName ), 'micTestSetupInfo', 'r_mic', 'micSpectra', 'frequencies', '-v7.3');
    
    %add noise with different SNRs
    micSpectraNoiseless = micSpectra;
    for ii=1:length(noise_snr)
        [micSpectra] = injectNoiseIntoSignal(micSpectraNoiseless, noise_snr(ii));
        
        fileNameNoise = sprintf('%s noise %d dB', fileName, noise_snr(ii));
        
        save(fullfile(micSetupsPath, fileNameNoise ), 'micTestSetupInfo', 'r_mic', 'micSpectra', 'frequencies', '-v7.3');
    end
    
    %% 32 MICS REGULAR GRID
    fileName = '32 mics regular setup';
    micTestSetupInfo.nMics = 32;
    acprRegularGridNSamples = [8 4]; % number of microphones (i.e samples) along X and Y axes
    subGridMicDist = [4 8]; %how many acpr hologram plane points should lie between microphones
    [r_mic, micSpectra] = subSampleRegularCenteredMicGrid(acpr_r_holo, acpr_spectra, acpr_axes_n_samples, acprRegularGridNSamples, subGridMicDist);
    
    save(fullfile(micSetupsPath, fileName ), 'micTestSetupInfo', 'r_mic', 'micSpectra', 'frequencies', '-v7.3');
    
    
    %% 64 MICS RANDOM GRID
    fileName = '64 mics random setup';
    micTestSetupInfo.nMics = 64;
    
    [r_mic, micSpectra] = subSampleRandomMicGrid(acpr_r_holo, acpr_spectra, 64);
    
    save(fullfile(micSetupsPath, fileName ), 'micTestSetupInfo', 'r_mic', 'micSpectra', 'frequencies', '-v7.3');
    
    %add 10 dB noise
    micSpectraNoiseless = micSpectra;
    [micSpectra] = injectNoiseIntoSignal(micSpectraNoiseless, noise_snr(2));
    
    fileNameNoise = sprintf('%s noise %d dB', fileName, noise_snr(ii));
    
    save(fullfile(micSetupsPath, fileName ), 'micTestSetupInfo', 'r_mic', 'micSpectra', 'frequencies', '-v7.3');
    
    %% 64 MICS REGULAR GRID
    fileName = '64 mics regular setup';
    micTestSetupInfo.nMics = 64;
    acprRegularGridNSamples = [8 8];
    subGridMicDist = [4 4]; %how much acpr hologram plane points should lie between microphones
    [r_mic, micSpectra] = subSampleRegularCenteredMicGrid(acpr_r_holo, acpr_spectra, acpr_axes_n_samples, acprRegularGridNSamples, subGridMicDist);
    
    save(fullfile(micSetupsPath, fileName ), 'micTestSetupInfo', 'r_mic', 'micSpectra', 'frequencies', '-v7.3');
    
    %% 128 MICS REGULAR GRID
    fileName = '128 mics regular setup';
    micTestSetupInfo.nMics = 128;
    acprRegularGridNSamples = [14 8];
    subGridMicDist = [1 4]; %how much acpr hologram plane points should lie between microphones
    [r_mic, micSpectra] = subSampleRegularCenteredMicGrid(acpr_r_holo, acpr_spectra, acpr_axes_n_samples, acprRegularGridNSamples, subGridMicDist);
    
    save(fullfile(micSetupsPath, fileName ), 'micTestSetupInfo', 'r_mic', 'micSpectra', 'frequencies', '-v7.3');
    
    
    %% 128 MICS RANDOM GRID
    fileName = '128 mics random setup';
    micTestSetupInfo.nMics = 128;
    
    [r_mic, micSpectra] = subSampleRandomMicGrid(acpr_r_holo, acpr_spectra, 128);
    
    save(fullfile(micSetupsPath, fileName ), 'micTestSetupInfo', 'r_mic', 'micSpectra', 'frequencies', '-v7.3');
    
end



