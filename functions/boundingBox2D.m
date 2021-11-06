function [bb] = boundingBox2D(points)

bb.minX = min(points(:, 1));
bb.maxX = max(points(:, 1));

bb.minY = min(points(:, 2));
bb.maxY = max(points(:, 2));

end