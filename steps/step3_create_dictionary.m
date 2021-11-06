%This script computes the compressed dictionary starting from the provided
%equivalent sources set. The operation is repeated for each boundary
%conditions folder. The dictionary will comprehend: D matrix, which
%concatenates all the different pca compressed eq sources matrices, mode by
%mode: [S_comp_mode1 ... S_comp_modeM]. D_by_modes: a cell array which
%splits the dictionary in cells. Each cell refers to one single mode. This
%struct is organized as the uncompressed equivalent sources dataset.

% Matlab PCA summary
% coeff : principal component coefficients, also known as loadings.
% 
% score : are the representations of X in the principal component space. 
%           Rows of score correspond to observations, and columns correspond 
%           to components.
%           
% latent : principal component variances. The principal component variances 
%            are the eigenvalues of the covariance matrix of X.
%               
% tsquareed : (NOT USED) Hotelling's T-squared statistic for each 
%               observation in X 
%               
% explained:  percentage of the total variance explained by each principal
%             component.
% 
% mu : estimated mean of each variable in X.
% NOTE: principal components are returned in descending order in terms of
% component variance (latent)

main;

%% LOAD GEOMETRY AND STRUCTURE DATA
load_geometry_and_structure_data;

%% LOAD EQUIVALENT SOURCES DATA
load(fullfile(folder.data, scenario, file.equivalentSourcesParameters));

%% COMPUTE DICTIONARIES FOR ALL BOUNDARY CONDITIONS
listing = dir(fullfile(folder.data, scenario, folder.boundaryConditions));
listing = listing(3:end);

D_by_bc = cell(length(listing), 1);
D_frequencies_by_bc = cell(length(listing), 1);
D_groups_by_bc = cell(length(listing), 1);

kk = 1;

for i=1:length(listing)
    
    boundaryConditionsPath = fullfile(listing(i).folder, listing(i).name);
    
    load(fullfile(boundaryConditionsPath, file.equivalentSources));
    
    %uncompressed dictionary allocation
    D_by_modes = cell(structureParameters.numberOfFEMModes, 1);

    D = [];
    D_groups = [];
    D_frequencies = zeros(structureParameters.numberOfFEMModes, 2);

    for mode = 1:structureParameters.numberOfFEMModes
    
        Q_m = Q_weights{mode};
        
        %keep the frequency range for each mode
        D_frequencies(mode, 1) = min(Q_frequencies(:, mode));
        D_frequencies(mode, 2) = max(Q_frequencies(:, mode));

        %do not normalize eq sources before pca!
        Q_m = transpose(Q_m); %param sets correspond to observations, equivalent sources correspond to variables

        [loads, score, latent, ~, explained, mu]  = pca(Q_m, 'Algorithm', 'svd', 'Centered', true);

        [compressedPrincipalComponentsArray] = compressPrincipalComponentsArray(loads, latent, dictionaryThreshold);
        
        D = [D compressedPrincipalComponentsArray];
                
        D_by_modes{mode} = compressedPrincipalComponentsArray;
        
        group = kk*ones(1, size(compressedPrincipalComponentsArray, 2));
        
        D_groups = [D_groups group];
        
        kk = kk+1;

    end 
    
    D_by_bc{i, 1} = D_by_modes;
    D_frequencies_by_bc{i, 1} = D_frequencies;

    save(fullfile(boundaryConditionsPath, file.dictionary), 'D_by_modes', 'D', 'D_groups', 'D_frequencies', '-v7.3');
end

save(fullfile(folder.data, scenario, file.dictionaryComplete), 'D_by_bc', 'D_frequencies_by_bc', '-v7.3');
