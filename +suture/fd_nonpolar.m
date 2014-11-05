function ZofT = fd_nonpolar(FT, T, delta_0)
% FD_NONPOLAR  Reconstruct the difference in z
%   between z(0), and z(T) from the Fourier Series Terms FT.
%
%   z = FD_NONPOLAR(FT, T)
%   z = FD_NONPOLAR(FT, T, delta_0), delta_0 is the starting angle
%
% @param FT an array [As, Bs], k = 0 -> N
% @param T  a scalar or vector, the point(s) at which the difference
%   wishes to be calculated
% @return [x, y] = z(t) - z(0) = x(t) - x(0) + i(y(t) - y(0)
%
% Supporting equations:
%   z(t) - z(0) = \frac{L}{2\pi} \int_0^t exp(i * \phi^*(t)) dt
%     \phi*(t) = -t + \delta_0 + \sum_{k=1}^n \gamma(k, t)
%     \gamma = A_k*cos(kt) + B_k*sin(kt)
%
% Supporting paper:
%   Zahn, Charles, "Fourier Descriptors for Plane Closed Curves.", 1972

  if nargin < 3
    delta_0 = 0;
  end

  if (~isa(FT, 'suture.FourierTerms'))
    error('Passed FT is not an instance of FourierTerms')
  end

  As = FT.cos_terms;   % Set of A_k
  Bs = FT.sin_terms;   % Set of B_k
  N = FT.truncation_length;
  d_0 = delta_0;

  % Helper functions
  A = @(k) As(k+1); % As is 0 indexed(i.e. index 1 <=> A_0)
  B = @(k) Bs(k+1);

  % gamma(k, t) = A_k*cos(kt) + B_k*sin(kt)
  gamma = @(t, k) A(k)*cos(k*t) + B(k)*sin(k*t);

  % gamma_map is a function that returns an array for which
  % gamma is applied at t, for k = 0...n
  sum_gamma = @(t) sum(arrayfun((@(k) gamma(t, k)), 0:N));

  % \phi^*(t) = -t + \delta_0 + \sum_{k=0}^n \gamma(k, t)
  phi_star = @(t) -t + d_0 + sum_gamma(t);

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
  % Assuming L = 2pi, we have scale_factor = 1
  scale_factor = 1;

  % z(t) - z(0) = \frac{L}{2\pi} \int_0^t exp(i * \phi^*(t)) dt
  z = @(t) scale_factor * integral(exp_phi_star, 0, t, 'ArrayValued', true);

  if length(T) == 1
    ZofT = z(T);
  else
    ZofT = arrayfun(z, T);
  end
end
