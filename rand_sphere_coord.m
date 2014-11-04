function x = rand_sphere_coord(r, N)
  % RAND_SPHERE_COORD  returns a random coordinate on a N-dimensional
  % sphere of radius r.
  %
  % Proof(ish):
  % The sphere is defined by
  %   \sum x_i^2 = r^2
  % We find a point iteratively by doing this
  % at every step:
  %  Since x_i is *at most* xi_max(x) = r^2 - sum_{j \neq i} x_j^2,
  %  then we define x_i to be rand(0..xi_max)
  %  And we set the last one, x_N = xi_max(x);
  x = zeros(N, 1);
  xi_max = @(x) sqrt(r^2 - sum(x.*x));
  for i = 1:N-1
    x(i) = xi_max(x)*rand(1);
    x(i) = randflip(x(i));
  end
  x(N) = xi_max(x); % the rest
end

function y = randflip(x)
  y = x;
  if rand(1) > 0.5
    y = -x;
  end
end
