function T=tr(x,y,z,alpha)

ca = cos(alpha);
sa = sin(alpha);

T = [ca -sa 0 x;
    sa ca 0 y;
    0 0 1 z;
    0 0 0 1];
