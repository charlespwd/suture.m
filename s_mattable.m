A1 = 0:0.25:1;
a1 = 0:0.25:1;
A2 = 0:0.25:1;
a2 = 0:0;
t_interval = 0:0.25:(2*pi+0.25);

tostr = @(x) strrep(num2str(x), '.', ',')
filename = @(A,a) strcat('A(', tostr(A), '), a(', tostr(a), ')')
for k = 1:length(A2)
  for m = 1:length(a2)
    h = figure;
    for i = 1:length(A1)
      for j = 1:length(a1)
        As = [A1(i), A2(k)];
        as = [a1(j), a2(m)];
        FD = FourierDescriptors(As, as)
        z = arrayfun(@(t) fd_reconstruct_z_difference_at_t(FD, t, pi/2), t_interval);
        subplot(length(A1), length(a1), (i-1)*(length(a1)) + j)
        plot(z);
        axis square;
        axis([-2 2 -2 2]);
        title(strcat('A: [', num2str(As), '], a: [', num2str(as), ']'));
      end
    end
    savefig(h, filename(A2(k), a2(m)))
    close(h);
  end
end
