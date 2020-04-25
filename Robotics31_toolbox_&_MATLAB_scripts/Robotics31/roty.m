function R = roty(theta)

cq = cos(theta);
sq = sin(theta);

R = [cq 0 sq;
    0  1 0;
    -sq 0 cq];