function z = sut(N, Pphi, Ph, dt)
  % SUT  plot suture with given N, P(h) and P(phi)

  if nargin < 2
    Pphi = 0.10;
  end

  if nargin < 3
    Ph = 0.085;
  end

  if nargin < 4
    dt = 0.05;
  end

  Aphis = abs(rand_sphere_coord(sqrt(Pphi), N));
  Ahs   = abs(rand_sphere_coord(sqrt(Ph), N));
  z = suture(Aphis, Ahs, 0:dt:(2*pi+dt));
  plot(z);
end
