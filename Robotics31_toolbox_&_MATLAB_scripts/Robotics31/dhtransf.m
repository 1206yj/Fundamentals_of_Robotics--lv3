function T = dhtransf(p)

cq = cos(p(1));
sq = sin(p(1));
ca = cos(p(4));
sa = sin(p(4));
d = p(2);
a = p(3);

T = [cq -sq*ca sq*sa a*cq; 
    sq cq*ca -cq*sa a*sq; 
    0 sa ca d; 
    0 0 0 1];
