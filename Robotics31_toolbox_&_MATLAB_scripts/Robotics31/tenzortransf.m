function Ds = tenzortransf(D, m, R, t)

Ds = R * D * R' + m * (t'*t*eye(3)-t*t');