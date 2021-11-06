function [fileData] = readFEMVelFile(fileName, numberOfParameterSets, numberOfFEMModes)

%input file organization: for each parameter set, for each eigenfrequency,
%normal vel component arrays are given on subsequent columns.

%output data: a cell array where each of its cells refers to a specific
%parameter set. Inner matrices contain the different eigenfrequency normal
%vel component values on their columns. Each subsequent column corresponds
%to the corresponding indexed eigenfrequency.

fileContentMatrix = csvread(fileName);

%discarding coordinates data (column 1 to 3)
fileContentMatrix = fileContentMatrix(:, 4:end);

%kk is used as a placeholder for a specific column of fileContentMatrix
kk = 1;

fileData = cell(1, numberOfParameterSets);

for ii = 1:numberOfParameterSets
    fileData{1, ii} = fileContentMatrix(:, kk:kk+numberOfFEMModes-1);
end

end
