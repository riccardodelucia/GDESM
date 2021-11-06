function [compressedPrincipalComponentsArray] = compressPrincipalComponentsArray(principalComponentsArray, lambdas, th)

%This function compress the principalComponentsArray by keeping only
%components satisfying the defined threshold policy.

compressedPrincipalComponentsArray = principalComponentsArray(:, 1);
for ii=2:length(lambdas)
    db(abs(lambdas(1))/abs(lambdas(ii)), 'power')

    %the higher the ratio, the higher the difference in energy between the
    %first component and the current component. Low energy components make
    %this ratio explode.
    if(db(abs(lambdas(1))/abs(lambdas(ii)), 'power')<th)
        compressedPrincipalComponentsArray = [compressedPrincipalComponentsArray principalComponentsArray(:, ii)];
    else
        break;
    end
        
end

end