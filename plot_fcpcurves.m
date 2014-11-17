function plot_fcpcurves(As)
  import suture.fcmemo;
  if nargin < 1; As = {-1:.5:1 1:-1:-1}; end;
  if ~is_descending(As{2}); As{2} = sort(As{2}, 'descend'); end;
  memo = 0; fig_id = figure;

  for i = 1:length(As{1})
    for j = 1:length(As{2})
      memo = subplotcurve(@fcmemo, As, i, j, memo);
      disp_percent_progress(i,j,length(As{1}),length(As{2}));
    end
  end

  saveas(fig_id, figure_filename(As), 'png')
end

function memo = subplotcurve(memofn, As, i, j, memo)
  [A1, A2] = destructure(As);
  A = [A1(i), A2(j)];
  [z, memo] = memofn(A, false, memo);
  subplot(length(A2), length(A1), subplot_index(i, j, length(A1)));
  prettyplot(z, figure_title(A));
end

function prettyplot(z, plot_title)
  plot(z);
  title(plot_title);
  clear_labels_and_ticks;
  format_axes(z);
end

function clear_labels_and_ticks()
  xlabel('');
  ylabel('');
  set(gca,'XTick',[]);
  set(gca,'YTick',[]);
end

function format_axes(z)
  axis square
  m = @(z) range_plus_padding(z, 0.05);
  if (is_straight_line(z))
    axis([m(real(z)) m(imag(z))]);
  else
    axis([minmax(real(z)), -1 1]);
  end
end

function r = range_plus_padding(z, percentPad)
  R = [min(z) max(z)];
  padding = percentPad * (R(2) - R(1));
  r = [R(1) - padding, R(2) + padding];
end

function is_desc = is_descending(A)
   is_desc = length(A) > 2 && A(2) < A(1);
end

function t = figure_title(A)
  t = strcat('[', num2str(A, 2) , ']');
  % disp(t);
end

function fn = figure_filename(As)
  tostr    = @(x) strrep(num2str(x), '.', ',');
  filename = @(A) strcat('(', tostr(range_plus_padding(A{1},0)), '),(', tostr(range_plus_padding(A{2},0)) ,')');
  path     = @(A) strcat('figs/', filename(A));
  fn = path(As);
end

function bool = is_straight_line(z)
  bool = range(imag(z));
end

function k = subplot_index(i, j, num_of_columns)
  k = (j-1)*num_of_columns + i;
end

function [A1, A2] = destructure(As)
  A1 = As{1}; A2 = As{2};
end

function disp_percent_progress(i, j, M, N)
  MAX = M*N;
  current = subplot_index(j, i, N);
  progress_bar_template = '                                        ';
  progress_num = floor(current/MAX*length(progress_bar_template));
  progress_bar = regexprep(progress_bar_template, ['^\s{' num2str(progress_num) '}'], mult_str(progress_num, '#'));
  disp(['[' progress_bar ']']);
end

function multstr = mult_str(k, str)
  multstr = num2str(char(str*ones(1,k)));
end
