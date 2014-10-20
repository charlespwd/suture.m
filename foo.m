function Z = foo(k, n, c)
  if nargin < 3
    c = 0.25;
  end
  a = harmonic_amplitude(k, n);
  FD = FourierDescriptors(a, a);
  Z = arrayfun(@(xi) fd_reconstruct_z_difference_at_t(FD, xi, 0), 1:c:(2*pi+1.25));
  plot(Z)
end

% Z is closed if
%  1. A1 is a zero of the first bessel function and An = 0 for n>= 2
%  OR
%  2. An = 0 for all n =/= 0 mod k, for some k >= 2
%  e.g. mod 2 => 0, 1, 0, 1, 0, 1

