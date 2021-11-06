function [G_p] = compute_G_p(omega, c, rho_0, dst)
    G_p = 1j*rho_0*omega*exp(-1j*omega/c*dst)./(4*pi*dst);
end