function R = rotz(theta)

cq = cos(theta);
sq = sin(theta);

R = [cq -sq 0;    
    sq cq 0;
    0 0 1];