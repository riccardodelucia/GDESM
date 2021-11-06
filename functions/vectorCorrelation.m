function [corr] = vectorCorrelation(a, b)

a = a/norm(abs(a));
b = b/norm(abs(b));
corr = abs(ctranspose(a)*b) / (norm(a)*norm(b));


end