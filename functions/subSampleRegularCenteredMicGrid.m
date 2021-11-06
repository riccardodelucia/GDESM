function [subsetMicPos, subSetMicSpectra, subsetNMics] = subSampleRegularCenteredMicGrid(micCoordinates, micSpectra, acpr_axes_n_samples, subGridSize, subGridMicDist)

%this function subsamples an extended grid of microphones by picking up a
%subset from them. Choosen microphones form a regular grid. The output grid
%is centered wrt the original measurement plane mic grid center.

%add an index array for further retrieving correct spectra for the chosen
%microphones.
micSpectraIndexes = 1:length(micCoordinates)';

%reshaping mic grid to form the correct 2D grid pattern
micXGrid = reshape(micCoordinates(:, 1), acpr_axes_n_samples);
micYGrid = reshape(micCoordinates(:, 2), acpr_axes_n_samples);
micZGrid = reshape(micCoordinates(:, 3), acpr_axes_n_samples);

micSpectraGrid = reshape(micSpectraIndexes, acpr_axes_n_samples);

%find x and y subgrid acpr span in terms of acpr points. The span
%corresponds to the 'length' in terms of samples which is spanned from the
%mic grid on the hologram acpr sampled plane 
mic_n_x_samples_span = subGridSize(1)*(subGridMicDist(1)+1)-subGridMicDist(1);
mic_n_y_samples_span = subGridSize(2)*(subGridMicDist(2)+1)-subGridMicDist(2);

if mic_n_x_samples_span>acpr_axes_n_samples(1) || mic_n_y_samples_span>acpr_axes_n_samples(2)
    error('Mic grid is larger than the hologram plane. Reduce either the number of mics or the mic distance step\n');
end

%compute starting indexes on the x and y original grid for the subsampled
%grid.
xSubgridStartSample = floor((acpr_axes_n_samples(1)-mic_n_x_samples_span)/2)+1;
ySubgridStartSample = floor((acpr_axes_n_samples(2)-mic_n_y_samples_span)/2)+1;

%find all the indexes for x and y
subsampledGridXIndexes = xSubgridStartSample:subGridMicDist(1)+1:xSubgridStartSample+mic_n_x_samples_span-1;
subsampledGridYIndexes = ySubgridStartSample:subGridMicDist(2)+1:ySubgridStartSample+mic_n_y_samples_span-1;

%actual subsampling of the X and Y mic coordinates matrices and spectra
%indexes.
subsampledMicXGrid = micXGrid(subsampledGridXIndexes, subsampledGridYIndexes);
subsampledMicYGrid = micYGrid(subsampledGridXIndexes, subsampledGridYIndexes);
subsampledMicZGrid = micZGrid(subsampledGridXIndexes, subsampledGridYIndexes);

subSetMicSpectraIndexes = micSpectraGrid(subsampledGridXIndexes, subsampledGridYIndexes);

%creating the one dimensional array with (x, y) coordinates for the
%subsmpled mic grid.
subsetMicPos = [reshape(subsampledMicXGrid, [], 1) reshape(subsampledMicYGrid, [], 1) reshape(subsampledMicZGrid, [], 1)];

%retrieving spectra for the chosen microphones and put them into a one
%dimensional array too.
subSetMicSpectraIndexes = reshape(subSetMicSpectraIndexes, [], 1);
subSetMicSpectra = micSpectra(subSetMicSpectraIndexes, :);

%compute the total number of mics in the subsampled grid.
subsetNMics = subGridSize(1)*subGridSize(2);

end