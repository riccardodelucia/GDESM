function [acpr_r_holo, acpr_spectra, acpr_grid, acpr_boundary_coordinates] = extractAcprWithinStructureBoundingBox(acpr_r_holo, r_nodes, acpr_spectra)
%This function extracts acpr points within the structure boundaries

%add index reference to r_mic for filtering related micSpectra data points after
%filtering out-of-boundarybox mic coordinates
acpr_r_holo = [acpr_r_holo (1:length(acpr_r_holo))'];

acpr_r_holo = acpr_r_holo(acpr_r_holo(:, 1) > min(r_nodes(:, 1)), :);
acpr_r_holo = acpr_r_holo(acpr_r_holo(:, 1)<max(r_nodes(:, 1)), :);
acpr_r_holo = acpr_r_holo(acpr_r_holo(:, 2) > min(r_nodes(:, 2)), :);
acpr_r_holo = acpr_r_holo(acpr_r_holo(:, 2)<max(r_nodes(:, 2)), :);


acpr_spectra = acpr_spectra(acpr_r_holo(:, 4), :);

acpr_r_holo = acpr_r_holo(:, 1:3);

acpr_grid = [length(unique(acpr_r_holo(:, 1))) length(unique(acpr_r_holo(:, 2)))]; % the number of acpr points on x and y axes after filtering out-of-boundingbox points
acpr_boundary_coordinates = [min(acpr_r_holo(:, 1)) max(acpr_r_holo(:, 1)); min(acpr_r_holo(:, 2)) max(acpr_r_holo(:, 2))]; % the bounding box coordinates after filtering
end