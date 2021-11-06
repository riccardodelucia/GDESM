function plotDataOnMesh(normVelData, meshVertices, meshFaces, r_nodes)

%this function plots the desired field data by taking advantage of the
%structure mesh info V and F to correctly visualize the structure shape.
%The mesh data cannot be bypassed, as node points are not sufficient to
%compute back the correct shape (e.g taking into account holes in
%structures).

values = abs(normVelData); %vel is made by complex values

%Original stl file coordinates and coordinates in r_nodes could not
%coincide, or even be in different number. We therefore interpolate r_nodes
%values on the mesh nodes.
%interpValues = interpolateValues(r_nodes, meshVertices, values, 'linear');
interpValues = interpolateValues(r_nodes, meshVertices, values, 'natural');

plotFieldOnMesh(meshVertices, meshFaces, interpValues);

end