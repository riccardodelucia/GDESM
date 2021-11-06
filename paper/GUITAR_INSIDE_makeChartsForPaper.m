main;

scenario = 'GUITAR_eqsrcsINSIDE';


load_geometry_and_structure_data;

pathToFigures = fullfile(fileparts(which(mfilename)), folder.figures, scenario);
pathToFiguresBoundaryConditions = fullfile(pathToFigures, boundaryConditions);

mkdir(pathToFigures);
mkdir(pathToFiguresBoundaryConditions);


%% SETUP FOLDERS
simulationDataPath = fullfile(folder.data, scenario, folder.boundaryConditions, boundaryConditions);

acousticSimulationPath = fullfile(simulationDataPath, folder.acousticSimulation);
micSetupsPath = fullfile(simulationDataPath, folder.micSetups);
reconstructionPath = fullfile(simulationDataPath, folder.reconstruction);


%% LOAD GROUNDTRUTH DATA
load(fullfile(acousticSimulationPath, file.velGroundtruth));
load(fullfile(acousticSimulationPath, file.acprFrequencies));

numberOfReconstructedModes = length(acpr_frequencies);

%% LOAD EQUIVALENT SOURCES DATA
load(fullfile(folder.data, scenario, file.equivalentSourcesParameters));

%% 1) PLOT EQ SRC SETUP

fileNames = [ "64 mics random setup" ];

for i=1:length(fileNames)
    fileName = fileNames(i);
    load(fullfile(micSetupsPath, fileName));
    
    fig = figure('visible', 'off');
    fig.Position = [100 100 800 700];
    hold on;
    scatter(r_nodes(:, 1), r_nodes(:, 2), 'LineWidth', 0.01, 'MarkerEdgeColor', [0.5 0.5 0.5]);
    scatter(r_mic(:, 1), r_mic(:, 2), 'filled', 'k');

    legend('mics', 'structure points');
    axis equal;
    xlim([-0.3 0.3]);
    ylim([-0.3 0.3]);
    title('xy');
    set(gca, 'FontName', 'Times New Roman', 'FontSize', 20);
    saveas(fig, fullfile(pathToFiguresBoundaryConditions, sprintf('%s mics nodes xy', fileName)), 'png');

    fig = figure('visible', 'off');
    fig.Position = [100 100 800 700];
    hold on;
    scatter(r_nodes(:, 1), r_nodes(:, 2), 'LineWidth', 0.01, 'MarkerEdgeColor', [0.5 0.5 0.5]);
    scatter(r_q(:, 1), r_q(:, 2), '*', 'k');

    legend('structure points', 'equivalent sources');
    axis equal;
    xlim([-0.3 0.3]);
    ylim([-0.3 0.3]);

    title('xy');
    set(gca, 'FontName', 'Times New Roman', 'FontSize', 20);
    saveas(fig, fullfile(pathToFiguresBoundaryConditions, sprintf('%s nodes eq srcs xy plane', fileName)), 'png');

    fig = figure('visible', 'off');
    fig.Position = [100 100 800 700];

    scatter(r_mic(:, 1), r_mic(:, 3), 'filled', 'k');
    hold on;
    scatter(r_nodes(:, 1), r_nodes(:, 3), 'MarkerEdgeColor', [0.5 0.5 0.5]);
    scatter(r_q(:, 1), r_q(:, 3), '*', 'k');
    
    legend('mics', 'structure points', 'eq srcs');

    axis equal;
    xlim([-0.3 0.3]);
    ylim([-0.035 0.20]);
    title('Complete setup xz');
    set(gca, 'FontName', 'Times New Roman', 'FontSize', 20);
    saveas(fig, fullfile(pathToFiguresBoundaryConditions, sprintf('%s nodes eq srcs mics xz plane',  fileName)), 'png');

    fig = figure('visible', 'off');
    scatter(r_mic(:, 2), r_mic(:, 3), 'filled', 'k');
    hold on;
    scatter(r_nodes(:, 2), r_nodes(:, 3), 'MarkerEdgeColor', [0.5 0.5 0.5]);
    scatter(r_q(:, 2), r_q(:, 3), '*', 'k');
    legend('mics', 'structure points', 'eq srcs');

    axis equal;
    xlim([-0.3 0.3]);
    ylim([-0.035 0.25]);

    title('Complete setup yz');
    set(gca, 'FontName', 'Times New Roman', 'FontSize', 20);
    saveas(fig, fullfile(pathToFiguresBoundaryConditions, sprintf('%s nodes eq srcs mics yz plane', fileName)), 'png');

end

%% 2) GDESM RECONSTRUCTION PERFORMANCES ACCORDING TO MIC SETUPS
results = ["GDESM\32 mics regular setup", "GDESM\32 mics random setup"];

CORR = zeros(length(results), length(acpr_frequencies));

for i=1:length(results)
    load(fullfile(reconstructionPath, results(i), file.correlation));
    CORR(i, :) = corr;
end

fig = figure('visible','off');
fig.Position = [100 100 800 700];
hold on;
plot(acpr_frequencies, CORR(1, :), ':', 'Color', 'k', 'LineWidth', 1.5);
plot(acpr_frequencies, CORR(2, :), '--', 'Color', 'k', 'LineWidth', 1.5);

ylim([0 1.3]);
yticks([0 0.25 0.5 0.75 1]);
xlim([min(acpr_frequencies) max(acpr_frequencies)]);
xlabel('Frequency');
ylabel('Corr');
legend('32 mics regular', '32 mics random');
set(gca, 'FontName', 'Times New Roman', 'FontSize', 20);
figureFileName = 'GDESM regular vs random grids - 64 mics';

saveas(fig, fullfile(pathToFiguresBoundaryConditions, figureFileName), 'png');
saveas(fig, fullfile(pathToFiguresBoundaryConditions, figureFileName), 'eps');
           
close(fig);


%% 3) RECONSTRUCTION ACCURACY ACCORDING TO THE NUMBER OF MICS

results = ["GDESM\64 mics random setup", "GDESM\32 mics random setup", "GDESM\32 mics random setup noise 15 dB", "GDESM\32 mics random setup noise 5 dB" ];

CORR = zeros(length(results), length(acpr_frequencies));

for i=1:length(results)
    load(fullfile(reconstructionPath, results(i), file.correlation));
    CORR(i, :) = corr;
end

fig = figure('visible','off');
fig.Position = [100 100 800 700];
hold on;
plot(acpr_frequencies, CORR(1, :), ':', 'Color', 'k', 'LineWidth', 1.5);
plot(acpr_frequencies, CORR(2, :), '--', 'Color', 'k', 'LineWidth', 1.5);
plot(acpr_frequencies, CORR(3, :), '-', 'Color', 'k', 'LineWidth', 1.5);
plot(acpr_frequencies, CORR(4, :), '-.', 'Color', 'k', 'LineWidth', 1.5);

ylim([0 1.3]);
yticks([0 0.25 0.5 0.75 1]);
xlim([min(acpr_frequencies) max(acpr_frequencies)]);
xlabel('Frequency');
ylabel('Corr');
legend('64 mics random', '32 mics random', '32 mics random noise 15 dB', '32 mics random noise 5 dB');
set(gca, 'FontName', 'Times New Roman', 'FontSize', 20);
figureFileName = 'GDESM correlations for different mic setups';

saveas(fig, fullfile(pathToFiguresBoundaryConditions, figureFileName), 'png');
saveas(fig, fullfile(pathToFiguresBoundaryConditions, figureFileName), 'eps');

close(fig);

%plot reconstructed velocities
% for ii=1:length(file_data)
%     
%     fileName = file_data(ii);
% 
%     load([resultsFolder char(fileName)]);
%     
%     for jj=1:length(acpr_frequencies)
% 
%         fig = figure('visible', 'off');
%         subplot(121);
%         plotDataOnMesh(vel_groundtruth(:, jj), meshVertices, meshFaces, r_vel_groundtruth);
%         title(sprintf('Groundtruth'));
%         subplot(122);
%         plotDataOnMesh(reconstructedVelocities(:, jj), meshVertices, meshFaces, r_nodes);
%         title(sprintf('Reconstructed'));
% 
%         figureTitle = sprintf('Groundtruth vs reconstructed velocities mode %d freq %d Hz', jj, frequencies(jj));
% 
%         saveas(fig, [outputFolder figureTitle '.png']);
%         saveas(fig, [outputFolder figureTitle '.eps']);
%         close(fig);
% 
%     end
% 
% end
           

%% 4) COMPARE GDESM WITH ESM
results = ["GDESM\32 mics random setup noise 10 dB", "ESM\32 mics random setup noise 10 dB"];

CORR = zeros(length(results), length(acpr_frequencies));

for i=1:length(results)
    load(fullfile(reconstructionPath, results(i), file.correlation));
    CORR(i, :) = corr;
end

fig = figure('visible','off');
fig.Position = [100 100 800 700];
hold on;
plot(acpr_frequencies, CORR(1, :), ':', 'Color', 'k', 'LineWidth', 1.5);
plot(acpr_frequencies, CORR(2, :), '--', 'Color', 'k', 'LineWidth', 1.5);

ylim([0 1.3]);
yticks([0 0.25 0.5 0.75 1]);
xlim([min(acpr_frequencies) max(acpr_frequencies)]);
xlabel('Frequency');
ylabel('Corr');
legend('GDESM 32 mics random setup noise 10 dB', 'ESM 32 mics random setup noise 10 dB');
set(gca, 'FontName', 'Times New Roman', 'FontSize', 20);

figureFileName = 'GDESM vs ESM';

saveas(fig, fullfile(pathToFiguresBoundaryConditions, figureFileName), 'png');
saveas(fig, fullfile(pathToFiguresBoundaryConditions, figureFileName), 'eps');

close(fig);

%% 5) COMPARE GDESM WITH LASSO DESM
% results = ["C:\Users\rdelucia\Documents\MATLAB\GDESM\Data\PLATE_eqsrcsEXTENDED\boundary_conditions\freefree\reconstruction\GDESM\128 mics random setup" ];
% 
% CORR = zeros(length(results), length(acpr_frequencies));
% 
% for i=1:length(results)
%     pathToResults = results(i);
%     load(fullfile(pathToResults, file.correlation));
%     CORR(i, :) = corr;
% end
% 
% % file_data = strings(2, 1);
% % file_data(1) = '64 mics random noise 5 dB.mat';
% % file_data(2) = '32 mics random.mat';
% % file_data(3) = 'DESM_LASSO/LASSO 64 mics random.mat';
% % file_data(4) = 'DESM_LASSO/LASSO 32 mics random.mat';
% 
% %corr = computeCorrelationsForSelectedResults(resultsFolder, file_data, vel_groundtruth, numberOfReconstructedModes, r_nodes, r_vel_groundtruth);
% 
% fig = figure('visible','off');
% hold on;
% plot(acpr_frequencies, corr(1, :), ':', 'Color', 'k', 'LineWidth', 1.5);
% %plot(acpr_frequencies, corr(2, :), '--', 'Color', 'k', 'LineWidth', 1.5);
% %plot(acpr_frequencies, corr(3, :), '-', 'Color', 'k', 'LineWidth', 1.5);
% %plot(acpr_frequencies, corr(4, :), '-.', 'Color', 'k', 'LineWidth', 1.5);
% 
% ylim([0 1.3]);
% yticks([0 0.25 0.5 0.75 1]);
% xlim([min(acpr_frequencies) max(acpr_frequencies)]);
% %title('Reconstructed vs groundtruth velocities correlation for all mic tests');
% xlabel('Frequency');
% ylabel('Corr');
% %legend('64 mics random noise 5 dB', '32 mics random', 'LASSO 64 mics random', 'LASSO 32 mics');
% set(gca, 'FontName', 'Times New Roman', 'FontSize', 20);
% %figureTitle = sprintf('Regular vs random grids: 64 mics');
% 
% figureFileName = 'GDESM vs DESM';
% saveas(fig, fullfile(pathToFiguresBoundaryConditions, figureFileName), 'png');
% saveas(fig, fullfile(pathToFiguresBoundaryConditions, figureFileName), 'eps');
% 
% close(fig);










