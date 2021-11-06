%% LISTING RESULTS DATA
resultsDir = dir(pathToReconstruction);
resultsDir = resultsDir(3:end);

for f=1:length(resultsDir)
    
    results = resultsDir(f);
    
    resultsName = results.name;
    pathToFiguresByResult=fullfile(pathToFigures, resultsName);
    mkdir(pathToFiguresByResult);
    
    % resultsName is both the folder name and name of the result file
    pathToResults = fullfile(results.folder, resultsName);
    
    load(fullfile(pathToResults, file.results));
    
    fprintf('Comparing data for: %s\n', resultsName);
    
    numberOfReconstructedModes = length(frequencies);
    
    %% LOAD GROUNDTRUTH DATA
    load(fullfile(pathToAcousticSimulation, file.velGroundtruth));
    
    %% COMPUTE RECONSTRUCTED VELOCITIES AND CORRELATIONS
    corr = zeros(1, length(frequencies));
    
    for ii=1:length(frequencies)
        
        %the interpolation algorithm could influence the quality of correlation
        %(linear seems to give better results)
        [interpValues] = interpolateValues(r_nodes, r_vel_groundtruth, reconstructedVelocities(:, ii), 'linear');
        
        %plot reconstructed velocity
        figureTitle = sprintf('mode %d - %d Hz', ii, frequencies(ii));
        disp(figureTitle);

        fig = figure('visible', 'off');
        subplot(121);
        plotDataOnMesh(vel_groundtruth(:, ii), meshVertices, meshFaces, r_vel_groundtruth);
        title('Groundtruth');
        subplot(122);
        plotDataOnMesh(reconstructedVelocities(:, ii), meshVertices, meshFaces, r_nodes);
        title('Reconstructed');
        
        sgtitle(figureTitle);
        
        saveas(fig, fullfile(pathToFiguresByResult, figureTitle), 'png');
        
        close(fig);
        
        corr(ii) = vectorCorrelation(vel_groundtruth(:, ii), interpValues);
        
    end
    
    %% SAVE CORRELATION WITH GROUNDTRUTH
    save(fullfile(pathToResults, file.correlation), 'corr', 'frequencies', '-v7.3');

    %% PLOT MEAN CORRELATION FOR EACH RECONSTRUCTED MODE
    
    fig = figure('visible','off');
    
    plot(frequencies, corr);
    hold on;
    plot(frequencies, mean(corr)*ones(length(frequencies)));
    ylim([0 1.1]);
    xlim([min(frequencies) max(frequencies)]);
    title(sprintf('%s reconstruction performances', resultsName));
    xlabel('Frequency');
    ylabel('Corr');
    
    figureTitle = sprintf('%s correlation', resultsName);
    figureFileTitle = figureTitle;
    saveas(fig, fullfile(pathToFiguresByResult, figureTitle), 'png');
    
    close(fig);
    
end