function [velocities] = GDESM(frequencies, micSpectra, D_by_bc, D_frequencies_by_bc, r_mic, r_nodes, r_q, normData, physicsParameters, lambda)

%this function is used to reconstruct surface velocities starting from
%measurement plane data (microphones recordings spectra) and the
%dictionary.
velocities = zeros(size(r_nodes, 1), length(frequencies));

%% COMPUTE EQ SRC TO STRUCTURE NODES VECTORS AND RELATED DATA
Dist_node_q = zeros(size(r_nodes, 1), size(r_q, 1));
node_q_unit_vectors = cell(size(r_nodes, 1), size(r_q, 1));

for ii=1:size(r_nodes, 1)
    for jj = 1:size(r_q, 1)
        %compute the vector which goes from the j-th eq source to the i-th
        %structure node
        r_node_q = r_nodes(ii, :) - r_q(jj, :);
        
        %compute r_node_q length
        dist_node_q = norm(r_node_q);
        Dist_node_q(ii, jj) = dist_node_q;

        % find unit vector from the j-th eq source to the i-th structure
        % node
        r_node_q_normalized = r_node_q/dist_node_q;
        node_q_unit_vectors{ii, jj} = r_node_q_normalized;
    end
end

dst_mic_q = pdist2(r_mic, r_q);

for ii = 1:length(frequencies)
   
    fprintf('mode %d\n', ii);
    
    %% COMPUTE ESTIMATED EQUIVALENT SOURCES 
    %propagation matrix
    freq = frequencies(ii);
    omega = 2*pi*freq;
    
    % acoustic pressure
    %P: M_mic x nModes
    P = micSpectra(:,ii);
    
    %% CREATE SUBDICTIONARY
    [subD, subD_groups, selectedGroups] = createSubdictionary(D_by_bc, D_frequencies_by_bc, freq, length(D_by_bc));
    
    fprintf('Candidate dictionary modes:\n');
    disp(selectedGroups);
    
    %% COMPUTE ESTIMATED EQUIVALENT SOURCES
    %G_p: M x U
    [G_p] = compute_G_p(omega, physicsParameters.c, physicsParameters.rho_0, dst_mic_q);
    H = G_p*subD;
    
    %group lasso
    options = spgSetParms('verbosity', 0);
    gammaArray = spg_group(H, P, subD_groups, lambda, options);

    %% RECONSTRUCT VIBRATION PROFILE FROM EQ SOURCES
    [G_sv] = compute_G_sv(omega, physicsParameters.c, normData, node_q_unit_vectors, Dist_node_q, size(r_nodes, 1), size(r_q, 1));

    v_est = G_sv*subD*gammaArray;
    
    velocities(:, ii) = v_est;
        
end

end