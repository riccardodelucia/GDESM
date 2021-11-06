function [r_q, U_q, U_xAxis, U_yAxis] = arrangeEqSourcesOnTheQPlane(QPlaneWidth, QPlaneHeight, z_q, QDiscretizationStepX, QDiscretizationStepY)

%this function arranges equivalent sources on the q plane according to the
%provided parameters.
%input parameters:
% QPlaneWidth, QPlaneHeight: the Q plane dimensions in meters
% z_q: the z coordinate for the Q plane
% QDiscretizationStepX, QDiscretizationStepY: the discretization step
% for discretizing the Q plane, i.e the distances between subsequent eq
% sources along x and y dimensions.

%output parameters:
% r_q: the x, y, z eq sources coordinates
% U_q: the total number of equivalent sources
% U_xAxis: the number of equivalent sources on the x axis
% U_yAxis: the number of equivalent sources on the y axis

%number of ES on the x and y axes
U_xAxis = round(QPlaneWidth/QDiscretizationStepX); 
U_yAxis = round(QPlaneHeight/QDiscretizationStepY);

% Total number of ESs
U_q = U_xAxis*U_yAxis; 

% computing ES coordinates along the axes. Each ES will have one of these
% values for x, y, z.
q_xCoordinates = (-U_xAxis/2+1:U_xAxis/2)*QDiscretizationStepX - QDiscretizationStepX/2;
q_yCoordinates = (-U_yAxis/2+1:U_yAxis/2)*QDiscretizationStepY - QDiscretizationStepY/2;
q_zCoordinates = z_q; 

% creating meshgrid for putting ES on the q plane
[Xes,Yes,Zes] = meshgrid(q_xCoordinates, q_yCoordinates, q_zCoordinates);

% linearize meshgrid data on a one dimensional array
r_q = zeros(U_q, 3);
r_q(:, 1) = Xes(:); %ES coordinates
r_q(:, 2) = Yes(:);
r_q(:, 3) = Zes(:);

%equivalent sources plane is automatically aligned such that its bounding
%box center lies on (0, 0) in the coordinate system
[r_q] = alignPlane(r_q, [0 0]);

end