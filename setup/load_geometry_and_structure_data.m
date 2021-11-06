%This script loads geometrical information for one particular structure.

%% LOAD DATA
[meshFaces, meshVertices] = stlread(fullfile(folder.data, scenario, file.mesh));

load(fullfile(folder.data, scenario, file.nodes));
load(fullfile(folder.data, scenario, file.normals));