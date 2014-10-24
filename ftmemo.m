function [z, memo] = ftmemo(FT, memo)
  if nargin < 2
    filename = '_ftmemo.db';
    dt = 0.1;
    t_interval = 0:dt:(2*pi+dt);
    f = @(FT) arrayfun(@(t) fd_nonpolar(FT, t, 0), t_interval)
    hasher = @(x) strjoin(cellstr(['{' num2str(x.cos_terms) '},{' num2str(x.sin_terms) '}']));
    serializer = @(x) [real(x) imag(x)];
    deserializer = @(x) x(1:length(x)/2) + 1*i*x(length(x)/2+1:length(x));
    memo = Memo(filename, f, hasher, serializer, deserializer);
  end

  z = memo.read(FT);
end
