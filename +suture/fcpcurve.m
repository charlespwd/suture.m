function ZofT = fcpcurve(A, T)
% FCPCURVE  reconstruct a plane curve with Fourier Descriptors
%
%   z = FCPCURVE(A, T)
%
% @param A  an array [a_k], k = 1:N
% @param T  a scalar or an array, the point(s) at which the difference wishes
%   to be calculated
% @return ZofT = z(t) - z(0) = x(t) - x(0) + i(y(t) - y(0)
%
% Assumptions:
%   1. The curve is parametrize by arc length. (i.e. periodic on 0:2pi)
%   2. We impose the slope at 0 and 2pi to be 0. %
%
% Derivation:
%   We want to transform a curve \theta(t): t -> \mathbb{R}, expressed as a Fourier series
%     \theta(t) = \sum_{k=1}^\infty a_k * sin(k*t) + \sum_{k=0}^\infty B_k * cos(k*t)
%   Into a curve z(t): \mathbb(R) -> \mathbb(C) such that \theta = tan^{-1} dy/dx
%   Thus we know,
%     z(t+dt) = z(t) + dt*\hat{\Theta(t)}
%   where \hat{\Theta(t)} = cos\theta + 1i*sin\theta = exp(1i*\theta)
%   We take the limit to get the following:
%     lim_{dt->0} \dfrac{z(t+dt) - z(t)}{dt} = \hat{\Theta(t)}
%     or
%     \dfrac{dz}{dt} = exp(1i*\theta(t)).
%   We integrate between 0 and t to recover the curve(assuming z(0) = 0):
%     z(t) = \int_0^t \exp(1i*\theta(t)) dt
%   Subject to the following boundary conditions:
%     z(0) = 0,
%     z(2*pi) = 0.
%   Since the set {cos(kt), sin(kt)}_{k=0}^\infty linearly independent, then
%   z(0) = z(2*pi) = 0 is only possible if b_k = 0 \forall k.
%   Therefore, we construct curves with
%     z(t) = \int_0^t exp(1i * theta(t)) dt, and
%     theta(t) = sum_{k=1}^\infty a_k * sin(k*t)

  if nargin < 2; T = 0:0.05:2*pi+0.05; end

  N = length(A);

  term         = @(t, k) A(k) * sin(k*t);
  terms        = @(t) arrayfun(@(k) term(t, k), 1:N);
  theta        = @(t) sum(terms(t));
  exp_i_theta  = @(t) exp(1i * theta(t));
  z            = @(t) complex(integral(exp_i_theta, 0, t, 'ArrayValued', true));

  ZofT = arrayfun(z, T);
end
