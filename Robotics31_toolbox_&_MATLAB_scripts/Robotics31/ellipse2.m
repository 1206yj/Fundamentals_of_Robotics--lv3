function [x, y]=ellipse2(P, x0, y0, res);

a=P(1,1);
b=P(1,2);
c=P(2,2);
phi=[0:2*pi*res:2*pi]';
r=1./sqrt(((a*cos(phi).^2+c*sin(phi).^2)+b*sin(2*phi)));
x=r.*cos(phi)+x0;
y=r.*sin(phi)+y0;
