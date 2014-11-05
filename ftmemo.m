function [z, memo] = ftmemo(FT, force, memo, filename, dt)
  % Reconstructs a shape from FourierTerms with fd_nonpolar using a persistent
  % memoization table, with option to force the calculation to happen.
  if nargin < 5
    dt = 0.1;
  end

  if nargin < 4
    filename = '_ftmemo.db';
  end

  if nargin < 3 || ~isa(memo, 'memo')
    t_interval = 0:dt:(2*pi+dt);
    f = @(FT) fd_nonpolar(FT, t_interval, 0);
    hasher = @(x) strjoin(cellstr(['{' num2str(x.cos_terms) '},{' num2str(x.sin_terms) '}']));
    serializer = @(x) [real(x) imag(x)];
    deserializer = @(x) x(1:length(x)/2) + 1i*x(length(x)/2+1:length(x));
    memo = Memo(filename, f, hasher, serializer, deserializer);
  end

  if nargin < 2
    force = false;
  end

  if force
    memo.remove(FT);
  end

  z = memo.read(FT);
end
