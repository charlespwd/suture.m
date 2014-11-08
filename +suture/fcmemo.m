function [z, memo] = fcmemo(A, force, memo, filename, dt)
  % FCMEMO  memoized version of fcpcurve
  import suture.fcpcurve suture.Memo

  if nargin < 5
    dt = 0.1;
  end

  if nargin < 4
    filename = '_fcmemo.db';
  end

  if nargin < 3 || ~isa(memo, 'suture.memo')
    t_interval = 0:dt:(2*pi+dt);
    f = @(A) fcpcurve(A, t_interval);
    hasher = @(x) strjoin(cellstr(['{' num2str(A) '}']));
    serializer = @(x) [real(x) imag(x)];
    deserializer = @(x) x(1:length(x)/2) + 1i*x(length(x)/2+1:length(x));
    memo = Memo(filename, f, hasher, serializer, deserializer);
  end

  if nargin < 2
    force = false;
  end

  if force
    memo.remove(A);
  end

  z = memo.read(A);
end

