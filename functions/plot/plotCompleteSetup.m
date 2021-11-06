function [] = plotCompleteSetup(r_nodes, r_mic, r_q, fig1, fig2, fig3, fileName)

%this function is used to plot the complete configuration of equivalent
%sources, structure, and microphone discrete points. This is useful to
%get a visual overview of the complete setup.

figure(fig1);
scatter(r_mic(:, 1), r_mic(:, 2), 'filled');
hold on;
scatter(r_nodes(:, 1), r_nodes(:, 2));
legend('mics', 'structure points');
title(sprintf('%s xy view', fileName));
xlim([-0.3 0.3]);
ylim([-0.25 0.25]);

figure(fig2);
scatter(r_mic(:, 1), r_mic(:, 3), 'filled');
hold on;
scatter(r_nodes(:, 1), r_nodes(:, 3));
scatter(r_q(:, 1), r_q(:, 3));
ylim([-0.1 0.1]);

legend('mics', 'structure points', 'eq srcs');

title(sprintf('%s xz view', fileName));

figure(fig3);
scatter(r_mic(:, 2), r_mic(:, 3), 'filled');
hold on;
scatter(r_nodes(:, 2), r_nodes(:, 3));
scatter(r_q(:, 2), r_q(:, 3));

ylim([-0.1 0.1]);

legend('mics', 'structure points', 'eq srcs');
title(sprintf('%s yz view', fileName));


end