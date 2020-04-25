function object = addrefframe(object, T, l)

X = T*[zeros(3,1) l*eye(3); ones(1,4)];

L = [1, 2, 0, 0;
    1, 3, 0, 0;
    1, 4, 0, 0]';

object = merge3dlines(object, X, L);

