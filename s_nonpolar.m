As = {0:1, 0:1, 0:1, 0:1};
Bs = {0:1, 0:1, 0:1, 0:1};

memo = 0;

ftitle = @(a,b,c,d,e,f,g,h) strcat('{',num2str([a,b,c,d]),'} {',num2str([e,f,g,h]),'}');
path = @(fn) strcat('./figs/', fn);

for a1=1:length(As{1})
for a2=1:length(As{2})
for a3=1:length(As{3})
for a4=1:length(As{4})
for b1=1:length(Bs{1})
for b2=1:length(Bs{2})
for b3=1:length(Bs{3})
for b4=1:length(Bs{4})
  t = ftitle(a1-1,a2-1,a3-1,a4-1,b1-1,b2-1,b3-1,b4-1);
  disp(t);

  A = [As{1}(a1), As{2}(a2), As{3}(a3), As{4}(a4)];
  B = [Bs{1}(b1), Bs{2}(b2), Bs{3}(b3), Bs{4}(b4)];
  [z, memo] = ftmemo(FourierTerms(A, B), false, memo);

  fid = figure;

  plot(z)
  title(t);
  saveas(fid, path(t), 'png');

  close(fid);
end
end
end
end
end
end
end
end

% CAREFULE THERE, THIS LOOP IS O(n^8) !!!
