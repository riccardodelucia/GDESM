function [fileContent] = readFEMNormFile(fileName)

%this function is used to extract the normal components of the undeformed
%structure. It also extracs the coordinate points where the normals have
%been calculated.

%input file organization:
%The file contains on the first 3 columns the (x, y, z) points coordinates, then the
%normal components for the surface normals wrt to the (X, Y, Z)
%coordinate system.

fileContentMatrix = csvread(fileName);   
fileContent{1, 1} = fileContentMatrix(:, 1:3);
fileContent{2, 1} = fileContentMatrix(:, 4:6);

end
