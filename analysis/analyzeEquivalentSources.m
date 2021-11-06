%This analysis script plots the shapes of the equivalent sources. All the
%three plane views are plotted (xy, xz, yz)

main;

%% LOAD GEOMETRY AND STRUCTURE DATA
load_geometry_and_structure_data;

%% MAKE OUTPUT FIGURES FOLDER
figuresPath = fullfile(folder.data, scenario, folder.figures, folder.equivalentSources);
mkdir(figuresPath);

%% LOAD EQUIVALENT SOURCES DATA
load(fullfile(folder.data, scenario, file.equivalentSourcesParameters));

%% PLOT EQUIVALENT SOURCES SECTION VIEWS
fig1 = figure('visible','off');
fig2 = figure('visible','off');
fig3 = figure('visible','off');

plotEqSourcesAndStructurePlanes(r_q, r_nodes, fig1, fig2, fig3);

figureFileTitle = 'Structure and equivalent sources position (xy view)';
saveas(fig1, fullfile(figuresPath, figureFileTitle), 'png');
figureFileTitle = 'Structure and equivalent sources position (xz view)';
saveas(fig2, fullfile(figuresPath, figureFileTitle), 'png');
figureFileTitle = 'Structure and equivalent sources position (yz view)';
saveas(fig3, fullfile(figuresPath, figureFileTitle), 'png');

close(fig1);
close(fig2);
close(fig3);
