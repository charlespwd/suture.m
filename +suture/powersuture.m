function z = powersuture(N, Pphi, Ph, dt)
  % POWERSUTURE  plot a suture with given N, P(h) and P(phi)
  import suture.rand_sphere_coord suture.suture;

  if nargin < 2; Pphi = 0.10; end;
  if nargin < 3; Ph   = 0.08; end;
  if nargin < 4; dt   = 0.05; end;

  Aphis = abs(rand_sphere_coord(sqrt(Pphi), N));
  Ahs   = abs(rand_sphere_coord(sqrt(Ph), N));

  z = suture(Aphis, Ahs, 0:dt:(2*pi+dt));
end
