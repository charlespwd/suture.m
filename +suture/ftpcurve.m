function ZofT = ftpcurve(FT, T, delta_0)
% FTPCURVE  reconstruct a plane cuver with fourier terms
%
%   z = FTPCURVE(FT, T)
%   z = FTPCURVE(FT, T, delta_0), delta_0 is the starting angle
%
% @param FT an array [As, Bs], k = 0 -> N
% @param T  a scalar or vector, the point(s) at which the difference
%   wishes to be calculated
% @return [x, y] = z(t) - z(0) = x(t) - x(0) + i(y(t) - y(0)
%
% ASSUMPTIONS: the length of the curve is 2*pi.
%
% Supporting equations:
%   z(t) - z(0) = \frac{L}{2\pi} \int_0^t exp(i * \phi^*(t)) dt
%     \phi*(t) = -t + \delta_0 + \sum_{k=1}^n \term(k, t)
%     \term = A_k*cos(kt) + B_k*sin(kt)
%
% Supporting paper:
%   Zahn, Charles, "Fourier Descriptors for Plane Closed Curves.", 1972

  if nargin < 3; delta_0 = 0; end;
  if (~isa(FT, 'suture.FourierTerms')); error('Passed FT is not an instance of FourierTerms'); end;

  A = @(k) FT.cos_terms(k+1); % As is 0 indexed(i.e. index 1 <=> A_0)
  B = @(k) FT.sin_terms(k+1);
  N = FT.truncation_length;
  d_0 = delta_0;

  term         = @(t, k) A(k)*cos(k*t) + B(k)*sin(k*t);
  sum_terms    = @(t) sum(arrayfun((@(k) term(t, k)), 0:N));
  phi_star     = @(t) -t + d_0 + sum_terms(t);
  exp_phi_star = @(t) exp(1i * phi_star(t));
  z            = @(t) integral(exp_phi_star, 0, t, 'ArrayValued', true);

  ZofT = arrayfun(z, T);
end
