function z = sut(isize, a, b, dt)
  if nargin < 4
    dt = 1;
  end

  if nargin < 3
    b = 0.005;
  end

  if nargin < 2
    a = 0.015;
  end

  Ahs = rand_sphere_coord(a, isize);
  Aps = rand_sphere_coord(b, isize);
  z = arrayfun(@(t) suture(Ahs, Aps, t), 1:dt:isize);
  plot(z);
end
