function [subD, subD_groups, selectedGroups] = createSubdictionary(D_by_bc, D_frequencies_by_bc, freq, nBC)
%this function is used to extract a subdictionary from the complete
%dictionary. The goal is to create a subdictionary where only dictionary
%parts referring to modes whose frequency range intersects the current
%analysis frequency are selected. Note: for robust reconstruction
%algorithms, this operation should not be necessary, as the optimization
%algorithm should be able to select data from the dictionary by itself.

%NOTE: subD_groups is a structure containing a number of indices referred
%to the selected groups. For each selected group, a number of indices equa
%to the number of group members is added to subD_groups. The first selected
%group will have index=1, independently of the group index in the complete
%dictionary. This data organization is needed by group lasso algorithm.

    subD = [];
    subD_groups = [];
    selectedGroups = [];
    groupIdx = 1;
    for jj=1:nBC
        D_freq = D_frequencies_by_bc{jj, 1};
        D_tmp = D_by_bc{jj, 1};
        for kk=1:length(D_freq)
            if freq>=D_freq(kk, 1) && freq<=D_freq(kk, 2)

                subD = [subD D_tmp{kk, 1}];
                groupLength = size(D_tmp{kk, 1}, 2);
                subD_groups = [subD_groups groupIdx*ones(1, groupLength)];
                groupIdx = groupIdx + 1;
                selectedGroups = [selectedGroups kk];
            end
        end
    end
end