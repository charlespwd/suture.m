classdef FourierDescriptors
  % FOURIERDESCRIPTORS  Literally, what they are.
  %
  %   FD = FourierDescriptors(As, Alphas, delta_0, mu_0)
  %
  % Suggested readings paper:
  %   Zahn, Charles, "Fourier Descriptors for Plane Closed Curves.", 1972

  properties
    harmonic_amplitudes,    % A = {A_k}
    harmonic_phase_angles,  % alpha = {alpha_k}
    truncation_length,      % N
    mu_0,                   % \mu_0
  end

  methods
    function FD = FourierDescriptors(As, Alphas)
      if (length(As) ~= length(Alphas))
        error('As and Alphas should have the same length');
      end
      FD.harmonic_amplitudes = As;
      FD.harmonic_phase_angles = Alphas;
      FD.truncation_length = length(As);
      FD.mu_0 = sum(arrayfun(@(k) As(k)*cos(Alphas(k)), 1:length(As)));
    end
  end
end

