function [fileContent] = readFEMEigenfreqFile(fileName, numberOfParameterSets, numberOfModes)

%this function is used to read eigenfrequencies for all the different
%parameter sets.

%input file organization: the input file contains concatenated frequencies
%for each parameter set. The first 'numberOfParameterSets' frequencies
%refer to the first parameter set, and so on.

fileContentArray = csvread(fileName);

%kk is used as a placeholder for a specific column of fileContentMatrix
kk = 1;

fileContent = zeros(numberOfParameterSets, numberOfModes);

for ii = 1:numberOfParameterSets
    fileContent(ii, :) = fileContentArray(kk:kk+numberOfModes-1);
    kk=kk+numberOfModes;
end
    
end