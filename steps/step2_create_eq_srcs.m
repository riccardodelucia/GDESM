%This script is used to compute equivalent sources from given FEM data.
%First of all, eq sources are positioned on an eq source plane. Then the
%corresponding weights are computed. The procedure is repeated for each
%boundary condition folder. As for FEM data, this script needs to be
%executed once for each structure and equivalent sources plane
%configuration. The eq_srcs_dataset contains several fields related to: the
%total number U of equivalent sources, the r_q equivalent sources
%coordinates in space, the equivalent sources plane z_q coordinate and a
%cell array containing the equivalent sources weights. Each column cell
%refers to a different mode. Each cell contains a U x nParameterSets array
%related to each parameter set.

% NOTE: Equivalent sources are sometimes referred to as q

main;

%% LOAD GEOMETRY AND STRUCTURE DATA
load_geometry_and_structure_data;


%% PUT ES ON THE EQUIVALENT SOURCES PLANE
%Note: Avoid misalignments among equivalent sources, structure and
%microphones!
[r_q, eqSourcesParameters.U_q, ~, ~] = arrangeEqSourcesOnTheQPlane(eqSourcesParameters.QPlaneWidth, eqSourcesParameters.QPlaneHeight, eqSourcesParameters.z_q, eqSourcesParameters.QDiscretizationStepX, eqSourcesParameters.QDiscretizationStepY);

%% TRIM OUT EQ SRCS THAT ARE OUT OF THE STRUCTURE BOUNDARIES (IF REQUESTED)
if eqSourcesParameters.trimEquivalentSourcesPlane
    [r_q, eqSourcesParameters.U_q] = extractPointsWithinBoundary(r_q, r_nodes);
end


%% DISTANCE VECTORS (EQUIVALENT SOURCES - STRUCTURE NODES) AND SCALAR PRODUCTS COMPUTATION

%r_node_q is the generic vector difference r_node-r_q, which is the
%distance vector between a structure node and an eq src
Dist_node_q = zeros(numberOfStructureSurfaceNodes, eqSourcesParameters.U_q);
node_q_unit_vectors = cell(numberOfStructureSurfaceNodes, eqSourcesParameters.U_q);
%projection of the normalized r_node_q to the surface normal in r_node

for i=1:length(r_nodes)
    for jj = 1:eqSourcesParameters.U_q
        %compute the vector which goes from the j-th eq source to the i-th
        %structure node
        r_node_q = r_nodes(i, :) - r_q(jj, :);
        
        %normalize r_node_q value in order to correctly compute a vector with
        %same direction but norm=1. This vector will be used along
        %with the derivative of the green propagator from one q to one
        %structure node to compute the green propagator gradient along the
        %direction that pass through theese points. The found
        %quantity will be finally used to compute the dot product with the
        %normal to surface for the structure point, obtaining the G_sv
        %desired value for the couple (q, structure node)
        
        dist_node_q = norm(r_node_q);

        r_node_q_normalized = r_node_q/dist_node_q;
        node_q_unit_vectors{i, jj} = r_node_q_normalized;
        
        %compute the scalar product to obtain the length of r_node_q in the
        %surface normal direction
        Dist_node_q(i, jj) = dist_node_q;
    end
end

%% SAVE ES GENERAL DATA
% NOTE: node_q_unit_vectors is not saved, since it is a very memory
% extended data structure.
save(fullfile(folder.data, scenario, file.equivalentSourcesParameters), 'r_q', 'Dist_node_q', '-v7.3');

%% COMPUTE EQUIVALENT SOURCES FOR ALL BOUNDARY CONDITIONS
listing = dir(fullfile(folder.data, scenario, folder.boundaryConditions));
listing = listing(3:end);

for i=1:length(listing)
    
    boundaryConditionsPath = fullfile(listing(i).folder, listing(i).name);
    mechanicSimulationPath = fullfile(boundaryConditionsPath, folder.mechanicSimulation);
    
    load(fullfile(mechanicSimulationPath, file.normVel));
    load(fullfile(mechanicSimulationPath, file.eigenfreqs));

    Q_weights = cell(structureParameters.numberOfFEMModes, 1);
    Q_frequencies = eigenfreqData;
    
    for mode = 1:structureParameters.numberOfFEMModes
        
        Q_m = zeros(eqSourcesParameters.U_q, structureParameters.numberOfParameterSets);
        
        for par = 1:structureParameters.numberOfParameterSets
            
            msg = sprintf('%s: mode %d/%d - param %d/%d', listing(i).name, mode, structureParameters.numberOfFEMModes, par, structureParameters.numberOfParameterSets);

            disp(msg);
            
            freq = eigenfreqData(par, mode);
            
            omega = 2*pi*freq;
            
            %compute the current G_sv propagation matrix.
            %G_sv has dimensions: NxU
            [G_sv] = compute_G_sv(omega, physicsParameters.c, normData, node_q_unit_vectors, Dist_node_q, numberOfStructureSurfaceNodes, eqSourcesParameters.U_q);
            
            %retrieve the current normal velocities data
            normVel = normVelData{par}(:, mode);

            %compute the equivalent sources by solving the L-curve + Tikhonov
            %prolem
            %[Q_m(:, par)] = ridgeRegression(G_sv, normVel);
            
            % OR Use Moore Penrose pseudo inverse
            [Q_m(:, par)] = pinv(G_sv)*normVel;

        end
    
        Q_weights{mode} = Q_m;
    
    end
    
    save(fullfile(boundaryConditionsPath, file.equivalentSources), 'Q_weights', 'Q_frequencies', '-v7.3');
    
end
