As = {[0:0] [0:0] [0:1] [0:1]}
Bs = {[0:0] [0:0] [0:1] [0:1]}

memo = 0;

for a1=1:length(As{1})
for a2=1:length(As{2})
for a3=1:length(As{3})
for a4=1:length(As{4})
for b1=1:length(Bs{1})
for b2=1:length(Bs{2})
for b3=1:length(Bs{3})
for b4=1:length(Bs{4})
  A = [As{1}(a1), As{2}(a2), As{3}(a3), As{4}(a4)];
  B = [Bs{1}(b1), Bs{2}(b2), Bs{3}(b3), Bs{4}(b4)];
  [z, memo] = ftmemo(FourierTerms(A, B), false, memo);
end
end
end
end
end
end
end
end

% CAREFULE THERE, THIS LOOP IS O(n^8) ...
