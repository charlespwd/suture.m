function [ A ] = harmonic_amplitude(k, n)
    %HARMONIC_AMPLITUDE  creates an array which satisfies
    % the closed curve conditions for the reconstruction of a
    % closed curve with Fourier Descriptors
    if k < 2
        error('please enter k: k >= 2')
    end

    if n < 1
        error('please enter n: n > 0')
    end

    f = @(i) (mod(i, k)==0) * 1;
    A = arrayfun(@(i) f(i), 1:n);

end

