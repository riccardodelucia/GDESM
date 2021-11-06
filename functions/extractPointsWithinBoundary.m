function [r_bounded, r_length, r_in_indexes] = extractPointsWithinBoundary(r_extended, r_with_boundary)

    k = boundary(r_with_boundary(:, 1), r_with_boundary(:, 2));
    external_boundary_shape = r_with_boundary(k, :);

    [r_in_indexes, ~] = inpolygon(r_extended(:, 1),r_extended(:, 2),external_boundary_shape(:, 1),external_boundary_shape(:, 2));
    r_bounded = r_extended(r_in_indexes, :);
    r_length = length(r_bounded);
end
