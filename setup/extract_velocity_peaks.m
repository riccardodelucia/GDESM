main;
fileName = 'acoustic_simulation_shell_velocity_curve.csv';

pathToFile = fullfile(folder.data, scenario, folder.boundaryConditions, boundaryConditions, folder.acousticSimulation);
vel = csvread(fullfile(pathToFile, fileName),5,0);

idx = islocalmax(vel(:, 2));

csvwrite(fullfile(pathToFile, [file.acprFrequencies '.csv']), vel(idx, 1));
writematrix(vel(idx, 1), fullfile(pathToFile, [file.acprFrequencies '.txt']))

