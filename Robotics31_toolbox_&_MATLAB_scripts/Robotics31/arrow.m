function [x, y] = arrow(x0, y0, alpha, L)

x = x0;
y = y0;
phi = alpha;

x(2) = x(1) + L * cos(phi);
y(2) = y(1) + L * sin(phi);

phi = phi + 3*pi/4;

x(3) = x(2) + 0.2 * sqrt(2) * L * cos(phi);
y(3) = y(2) + 0.2 * sqrt(2) * L * sin(phi);

phi = phi + 3*pi/4;

x(4) = x(3) + 0.4 * L * cos(phi);
y(4) = y(3) + 0.4 * L * sin(phi);

phi = phi + 3*pi/4;

x(5) = x(4) + 0.2 * sqrt(2) * L * cos(phi);
y(5) = y(4) + 0.2 * sqrt(2) * L * sin(phi);


