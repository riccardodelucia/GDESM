function [x, reg_corner] = ridgeRegression(A, b)

    [U_csvd, s_csvd, V_csvd] = csvd(A); %Compact SVD
    [reg_corner, ~, ~, ~] = l_curve(U_csvd, s_csvd, b, 'Tikh', 'off'); %L-curve
    [x, ~, ~] = tikhonov(U_csvd, s_csvd, V_csvd, b, reg_corner); %Tikhonov regularization
    
end