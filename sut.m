function z = sut(N, Ph, Pphi, dt)
  % SUT  plot suture with given N, P(h) and P(phi)
  map = @(x, f) arrayfun(f, x);

  if nargin < 4
    dt = 0.05;
  end

  if nargin < 3
    Pphi = 0.005;
  end

  if nargin < 2
    Ph = 0.015;
  end

  Ahs   = abs(rand_sphere_coord(sqrt(Ph), N));
  Aphis = abs(rand_sphere_coord(sqrt(Pphi), N));
  z = map(0:dt:(2*pi+dt), @(t) suture(Ahs, Aphis, t));
  plot(z);
end
