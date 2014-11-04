function Z = suture(AHs, APs, n_final)
  % For N points on the suture line
  % S(n) = (theta(n), h(n)).
  %
  % Scaled such that the length of the half-suture is pi
  % AHs(i) = Fourier amplitudes for the frequency i
  % APs(i) = Fourier amplitudes for the frequency i
  %
  % Suggested reading:
  %  Gildner, Raymond. "A Fourier Method to Describe And Compare
  %  Suture Patterns", Paleontologia Electronica, 2003.

  Ah = @(i) AHs(i+1);
  Ap = @(i) APs(i+1);
  N = length(AHs);
  hn = @(t) sum(arrayfun(@(i) Ah(i) * cos(i*t), 0:N-1));
  thetan = @(t) t - sum(arrayfun(@(i) Ap(i) * sin(i*t), 0:N-1));
  Z = 1i*hn(n_final) + thetan(n_final);
end
