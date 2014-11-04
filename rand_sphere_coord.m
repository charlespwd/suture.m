function x = rand_sphere_coord(r, N)
  % RAND_SPHERE_COORD  returns a random coordinate on a N-dimensional
  % sphere of radius r.
  x = zeros(N, 1);
  xi_max = @(x) sqrt(r^2 - sum(x.*x));
  for i = 1:N-1
    x(i) = xi_max(x)*rand(1);
  end
  x(N) = xi_max(x); % the rest
end
