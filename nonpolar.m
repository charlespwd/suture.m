dt = 0.05;
t_interval = 0:dt:(2*pi+dt);

As = [0,0,0,0,0,0];
Bs = [0,1,1,1,1,1];
FT = FourierTerms(As, Bs);
z = arrayfun(@(t) fd_nonpolar(FT, t), t_interval);
plot(z);
