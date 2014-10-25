As = [0.347, 0.371 1.001 0.384 0.575 0.423 .422 .128 .240 .081];
as = [0.698 5.687 4.989 3.279 4.588 1.084 0.004 4.283 4.084 4.708];
FD = FourierDescriptors(As, as);
dt = 0.05
t_interval = 0:dt:(2*pi+dt);
rot = -pi/2;
z = arrayfun(@(t) fd_polar(FD, t, rot), t_interval);
plot(z);
