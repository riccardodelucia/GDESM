function [signal_with_noise] = injectNoiseIntoSignal(X, noise_snr)
    
signal_with_noise = X;

for ii=1:size(X, 2)
    signal_with_noise(:, ii) = awgn(X(:, ii), noise_snr, 'measured', 'dB');
end

end