function [r_aligned, xShift, yShift] = alignPlane(r, centerCoordinates)

%The entire GDESM procedure is based on the hypothesis of aligned equivalent
%sources, structure source and measurement plane. This function takes an
%array of 3D points, computes the 2D bounding box and aligns its center to
%the provided center coordinates. This procedure has to be done before
%computing any Green's propagator, in order to avoid misalignment which
%could ruin the algorithm outcome.

[bb] = boundingBox2D(r);

%%equivalent sources plane center (avoid finite machine precision errors by coarse round)
bb_centerX = round((bb.maxX+bb.minX)/2, 4);
bb_centerY = round((bb.maxY+bb.minY)/2, 4);

xShift = bb_centerX - centerCoordinates(1);
yShift = bb_centerY - centerCoordinates(2);

%align equivalent sources plane (avoid finite machine precision errors by coarse round)
r_aligned = r;
r_aligned(:, 1) = r(:, 1) - xShift;
r_aligned(:, 2) = r(:, 2) - yShift;


end
