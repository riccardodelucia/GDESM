main;

%% MAKE OUTPUT FIGURES FOLDER
figuresPath = fullfile(folder.data, scenario, folder.figures, folder.equivalentSources);
mkdir(figuresPath);

%% LOAD GEOMETRY AND STRUCTURE DATA
load_geometry_and_structure_data;

%% LOAD EQUIVALENT SOURCES DATA PARAMETERS AND DICTIONARY
load(fullfile(folder.data, scenario, file.equivalentSourcesParameters));
load(fullfile(folder.data, scenario, file.dictionaryComplete));

listing = dir(fullfile(folder.data, scenario, folder.boundaryConditions));
listing = listing(3:end);

for i=1:length(listing)
    
    boundary_conditions=listing(i).name;
    boundaryConditionsPath = fullfile(listing(i).folder, listing(i).name);
    load(fullfile(boundaryConditionsPath, file.equivalentSources));
    load(fullfile(boundaryConditionsPath, folder.mechanicSimulation, file.normVel));
    
    dictionary = D_by_bc{i};

    %% PLOT EQ SRCS ABS WEIGHTS ACCORDING TO MODES
    for jj=1:6
        weights=Q_weights{jj, 1};
        weights=weights(:, 1); %use only first parameter set
        freq=Q_frequencies(1, jj);
        dictionaryByMode=dictionary{jj};
        

        %% PLOT EQ SRCS ABS WEIGHTS
        fig = figure('visible', 'off');
        
        figureTitle = sprintf('%s mode %d - %d Hz', boundary_conditions, jj, round(freq));
        sgtitle(figureTitle);
        
        set(gcf,'position',[0,0,1000,500])
        subplot(221);
        plotDataOnMesh(normVelData{1}(: , jj), meshVertices, meshFaces, r_nodes);
        %axis equal;
        title('mechanical velocity');
        
        subplot(222);
        scatter(r_q(:, 1), r_q(:, 2), 30, abs(weights), 'filled');
        axis([-0.2 0.2 -0.2 0.2]);
        axis equal;
        title('eq srcs')
        colormap(hot);
        colorbar();
        
        subplot(223);
        scatter(r_q(:, 1), r_q(:, 2), 30, abs(dictionaryByMode(:, 1)), 'filled');
        axis([-0.2 0.2 -0.2 0.2]);
        axis equal;
        title('1st dictionary component')
        colormap(hot);
        colorbar();
        
        subplot(224);
        scatter(r_q(:, 1), r_q(:, 2), 30, abs(dictionaryByMode(:, 2)), 'filled');
        axis([-0.2 0.2 -0.2 0.2]);
        axis equal;
        title('1st dictionary component')
        colormap(hot);
        colorbar();

        
        saveas(fig, fullfile(figuresPath, figureTitle), 'png');
        close(fig);
    end
    
    
    
end


