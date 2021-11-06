function [G_sv] = compute_G_sv(omega, c, normData, node_q_unit_vectors, Dist_node_q, r_nodes_length, q_length)
    wavenumber = omega/c;
    
    propagator = @(r_dist, k) 1./(4*pi*r_dist).*exp(-1j.*r_dist*k);
    G_sv = zeros(r_nodes_length, q_length);
    
    eta=sqrt(eps);
    
    for ii=1:r_nodes_length
        %compute Jacobian for derivatives
        J = (feval(propagator, Dist_node_q(ii, :), wavenumber)-feval(propagator, Dist_node_q(ii, :)+eta, wavenumber))/eta;
        for jj=1:q_length
            derivative_vector = node_q_unit_vectors{ii, jj}*J(jj);
            G_sv(ii, jj)=dot(normData(ii, :), derivative_vector);
        end
        %G_sv(ii, :) = J.*surf_normal_r_node_q_projection(ii, :); 
    end

end
