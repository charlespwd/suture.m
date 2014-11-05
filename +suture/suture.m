function ZofT = suture(Aphi, Ahs, T)
  % SUTURE  Calculates the value of a suture curve provided some
  %   Fourier coefficients Aphi, Ahs.
  %
  % Z = suture(Aphi, Ahs, t)
  %
  % Z(t) = theta(t) + i*h(t).
  %  theta = t - sum_{i=0}^N Ap(i) * sin(i*t)
  %  h     = 0 + sum_{i=0}^N Ah(i) * cos(i*t)
  %
  % Aphi(i) = Fourier amplitudes for the frequency i
  % Ahs(i) = Fourier amplitudes for the frequency i
  %
  % Suggested reading:
  %  Gildner, Raymond. "A Fourier Method to Describe And Compare Suture
  %  Patterns", Paleontologia Electronica, 2003.
  %    NOTE: See Eq 3A, 3B with n renormalized with t/pi = n/N
  %    NOTE: the N at the top of the sum is not the same as the N in the sum.
  %    This is not obvious.

  if length(Ahs) ~= length(Aphi); error('suture:dimensions', 'Dimensions of Ahs and Aphi must agree.'); end;

  N     = length(Ahs);
  Ap    = @(i) Aphi(i+1);
  Ah    = @(i) Ahs(i+1);
  theta = @(t) t - sum(arrayfun(@(i) Ap(i) * sin(i*t), 0:N-1));
  h     = @(t) 0 + sum(arrayfun(@(i) Ah(i) * cos(i*t), 0:N-1));
  Z     = @(t) theta(t) + 1i*h(t);

  ZofT = arrayfun(Z, T);
end
