function plot_fcpcurves(As)
  import suture.*
  if nargin < 1; As = {-1:0.5:1 -1:.5:1}; end;
  memo = 0;
  A1 = As{1};
  A2 = As{2};

  tostr = @(x) strrep(num2str(x), '.', ',');
  filename = @(A) strcat('(', tostr(range_plus_padding(As{1},0)), '),(', tostr(range_plus_padding(As{2},0)) ,')');
  path = @(A) strcat('figs/', filename(A));
  ftitle = @(A) strcat('[', num2str(A) , ']');

  h = figure;
  for i1 = 1:length(A1)
    for i2 = 1:length(A2)
      A = [As{1}(i1), As{2}(i2)];
      t = ftitle(A);
      disp(t);

      [z, memo] = fcmemo(A, false, memo);

      subplot(length(A1), length(A2), (i1-1)*(length(A2)) + i2)
      prettyplot(z, ftitle(A));
    end
  end
  saveas(h, path(A), 'png')
end

function prettyplot(z, plot_title)
  plot(z);
  title(plot_title);
  m = @(z) range_plus_padding(z, 0.05);
  if (is_straight_line(z))
    axis([m(real(z)) m(imag(z))]);
  else
    axis([minmax(real(z)), -1 1])
  end
end

function bool = is_straight_line(z)
  bool = range(imag(z));
end

function r = range_plus_padding(z, percentPad)
  R = [min(z) max(z)];
  padding = percentPad * (R(2) - R(1));
  r = [R(1) - padding, R(2) + padding];
end
