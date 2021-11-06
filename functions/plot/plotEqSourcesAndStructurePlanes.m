function [] = plotEqSourcesAndStructurePlanes(r_q, r_nodes, fig1, fig2, fig3)

%this function plots eq src and surface nodes to verify their relative
%positions in space. In particular, xy, xz and yz planes view are plotted.

figure(fig1);
scatter(r_q(:, 1), r_q(:, 2), 'filled');
hold on;
scatter(r_nodes(:, 1), r_nodes(:, 2), 'filled');
legend('equivalent sources', 'structure points');
title('xy view');
axis equal;

figure(fig2);
scatter(r_q(:, 1), r_q(:, 3), 'filled');
hold on;
scatter(r_nodes(:, 1), r_nodes(:, 3), 'filled');
legend('equivalent sources', 'structure points');
ylim([-0.1 0.1]);
title('xz view');
axis equal;

figure(fig3)
scatter(r_q(:, 2), r_q(:, 3), 'filled');
hold on;
scatter(r_nodes(:, 2), r_nodes(:, 3), 'filled');
legend('equivalent sources', 'structure points');
ylim([-0.1 0.1]);
title('yz view');
axis equal;

end