function [subsetMicPos, subSetMicSpectra] = subSampleRandomMicGrid(acpr_r_holo, acpr_spectra, nMics)

%this function randomly subsamples the acoustic pressure field

micSubgridIndexes = sort(randperm(length(acpr_r_holo), nMics));

subsetMicPos = acpr_r_holo(micSubgridIndexes, :);
subSetMicSpectra = acpr_spectra(micSubgridIndexes, :);

end
