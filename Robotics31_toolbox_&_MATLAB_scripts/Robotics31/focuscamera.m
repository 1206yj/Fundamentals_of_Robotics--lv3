function TC0 = focuscamera(XF0, alpha, beta, r);

ca = cos(alpha*pi/180);
sa = sin(alpha*pi/180);
cb = cos(beta*pi/180);
sb = sin(beta*pi/180);

XC0 = XF0 + [r*ca*cb r*sa*cb r*sb]';

ezC0 = XF0-XC0;
ezC0 = ezC0 / sqrt(ezC0'*ezC0);
exC0 = cross(ezC0, [0 0 1]');
exC0 = exC0 / sqrt(exC0'*exC0);
eyC0 = cross(ezC0, exC0); 

RC0 = [exC0 eyC0 ezC0];

TC0 = [RC0 XC0; 0 0 0 1];