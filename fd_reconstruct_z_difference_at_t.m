function z = fd_reconstruct_z_difference_at_t(FD, t_final, delta_0)
% FD_RECONSTRUCT_z_DIFFERENCE_AT_T  Reconstruct the difference in z
%   between z(0), and z(t_final) from the Fourier Descriptors FD.
%
%   z = FD_RECONSTRUCT_Z_DIFFERENCE_AT_T(FD, t_final)
%
% @param FD  an array [A_k, alpha_k], k = 1 -> N
% @param t_final  a scalar, the point at which the difference wishes to be calculated
% @return [x, y] = z(t) - z(0) = x(t) - x(0) + i(y(t) - y(0)
%
% Supporting equations:
%   z(t) - z(0) = \frac{L}{2\pi} \int_0^t exp(i * \phi^*(t)) dt
%     \phi*(t) = -t + \delta_0 + \mu_0 + \sum_{k=1}^n \gamma(k, t)
%     \gamma = A_k * cos(kt - \alpha_k)
%
% Supporting paper:
%   Zahn, Charles, "Fourier Descriptors for Plane Closed Curves.", 1972

  if (~isa(FD, 'FourierDescriptors'))
    error('Passed FD is not an instance of FourierDescriptors')
  end

  As = FD.harmonic_amplitudes;         % Set of A_k
  Alphas = FD.harmonic_phase_angles;   % Set of alpha_k
  N = length(As);     % Truncation size
  d_0 = delta_0;
  u_0 = FD.mu_0;
  
  % Helper functions
  A = @(k) As(k);
  alpha = @(k) Alphas(k);

  % mu_0 = sum_{k=1}^N A_k * cos(\alpha_k)
  %u_0 = sum(arrayfun(@(k) A(k)*cos(alpha(k)), 1:N));
  
  % gamma(k, t) = A_k * cos(kt - \alpha_k)
  gamma = @(t, k) A(k) * cos(k*t - alpha(k));

  % gamma_map is a function that returns an array for which
  % gamma is applied at t, for k = 1...n
  sum_gamma = @(t) sum(arrayfun((@(k) gamma(t, k)), 1:N));

  % \phi^*(t) = -t + \delta_0 + \mu_0 + \sum_{k=1}^n \gamma(k, t)
  phi_star = @(t) -t + d_0 + u_0 + sum_gamma(t);
  
  exp_phi_star = @(t) exp(1i * phi_star(t)); 

  % TODO: The scale factor kind of is a problem right now... Cause you need
  % to know the perimeter to construct the shape? That seems hard to
  % do... We'll see how this goes. We'll start by assuming the shape
  % perimeter to be 2*pi and scale to our needs after. 
  %
  % To be clear, the scale factor is the one corresponding to the
  % transformation from l -> t, where l \in [0, L] and t \in [0, 2pi]
  % => t/l = 2pi/L
  %
  % \therefore scale_factor should be = L / (2*pi);
  scale_factor = 1;

  % z(t) - z(0) = \frac{L}{2\pi} \int_0^t exp(i * \phi^*(t)) dt
  z = scale_factor * integral(exp_phi_star, 0, t_final, 'ArrayValued', true);
end
