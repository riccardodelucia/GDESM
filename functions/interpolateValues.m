function [interpValues] = interpolateValues(sourcePoints, destinationPoints, values, strategy)

interpolator = scatteredInterpolant(sourcePoints, values, strategy);

interpValues = interpolator(destinationPoints);

if(isempty(interpValues))
    interpolator = scatteredInterpolant(sourcePoints(:, 1:2), values, strategy);
    interpValues = interpolator(destinationPoints(:, 1:2));
end

end