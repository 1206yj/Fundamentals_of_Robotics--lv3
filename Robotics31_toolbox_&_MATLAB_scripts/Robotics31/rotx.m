function R = rotx(theta)

cq = cos(theta);
sq = sin(theta);

R = [1 0 0;
    0 cq -sq;
    0 sq cq];