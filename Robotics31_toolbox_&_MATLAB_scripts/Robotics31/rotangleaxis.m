function Rot = rotangleaxis(theta, k)

cs = cos(theta);
sn = sin(theta);
v = 1 - cs;

Rot = [k(1)^2*v+cs, k(1)*k(2)*v-k(3)*sn, k(3)*k(1)*v+k(2)*sn;
    k(1)*k(2)*v+k(3)*sn, k(2)^2*v+cs, k(3)*k(2)*v-k(1)*sn;
    k(3)*k(1)*v-k(2)*sn, k(3)*k(2)*v+k(1)*sn, k(3)^2*v+cs];