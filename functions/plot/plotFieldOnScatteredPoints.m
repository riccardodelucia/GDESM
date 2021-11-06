function plotFieldOnScatteredPoints(pointsCoordinates, field)

    %this function plots field values for scattered points, while providing
    %a smooth color interpolation among point values in order to build a
    %continuous field.
    field_abs = abs(field);
    DT = delaunayTriangulation(pointsCoordinates(:, 1:2));
    nodes=DT.Points;
    nodes = [nodes pointsCoordinates(:, 3)];
    plotFieldOnMesh(nodes, DT.ConnectivityList, field_abs);

end