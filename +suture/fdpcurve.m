function ZofT = fdpcurve(FD, T, d_0)
% FDPCURVE  reconstruct a plane curve with Fourier Descriptors
%
%   z = FDPCURVE(FD, T)
%
% @param FD  an array [A_k, alpha_k], k = 1 -> N
% @param T  a scalar or an array, the point(s) at which the difference wishes
%   to be calculated
% @return [x, y] = z(t) - z(0) = x(t) - x(0) + i(y(t) - y(0)
%
% Supporting equations:
%   z(t) - z(0) = \frac{L}{2\pi} \int_0^t exp(i * \phi^*(t)) dt
%     \phi*(t) = -t + \d_0 + \mu_0 + \sum_{k=1}^n \gamma(k, t)
%     \gamma = A_k * cos(kt - \alpha_k)
%
% Supporting paper:
%   Zahn, Charles, "Fourier Descriptors for Plane Closed Curves.", 1972

  if nargin < 3; d_0 = 0; end;
  if (~isa(FD, 'suture.FourierDescriptors')); error('Passed FD is not an instance of FourierDescriptors'); end;

  N = FD.truncation_length;
  u_0 = FD.mu_0;

  A            = @(k) FD.harmonic_amplitudes(k);
  alpha        = @(k) FD.harmonic_phase_angles(k);
  term         = @(t, k) A(k) * cos(k*t - alpha(k));
  sum_terms    = @(t) sum(arrayfun(@(k) term(t, k), 1:N));
  phi_star     = @(t) -t + d_0 + u_0 + sum_terms(t);
  exp_phi_star = @(t) exp(1i * phi_star(t));
  z            = @(t) integral(exp_phi_star, 0, t, 'ArrayValued', true);

  ZofT = arrayfun(z, T);
end
