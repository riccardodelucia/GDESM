main;

%% LOAD GEOMETRY AND STRUCTURE DATA
load_geometry_and_structure_data;

%% LOAD EQUIVALENT SOURCES AND DICTIONARY DATA
load(fullfile(folder.data, scenario, file.equivalentSourcesParameters));
load(fullfile(folder.data, scenario, file.dictionaryComplete));

%% LOAD SIMULATION DATA
simulationDataPath =fullfile(folder.data, scenario, folder.boundaryConditions, boundaryConditions);

micSetupsPath = fullfile(simulationDataPath,  folder.micSetups);
listing = dir(micSetupsPath);
listing = listing(3:end);

for i=1:length(listing)
    
    fileName = listing(i).name;

    fprintf(sprintf('%d) %s\n', i, fileName));

end

prompt = 'Which one would you like to reconstruct (type 0 for selecting all mic sets)?';
answer = input(prompt);

if answer == 0
    fileNameList = string(length(listing));
    for i=1:length(listing)
        fileNameList(i) = listing(i).name;
    end
else
    fileNameList =string(1);
    fileNameList(1) = listing(answer).name;
end
