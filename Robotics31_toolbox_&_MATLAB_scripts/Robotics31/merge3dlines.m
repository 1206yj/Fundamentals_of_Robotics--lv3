function object = merge3dlines(object, X2, VE2);

[m, nX1] = size(object.X);
[m, nL2] = size(VE2);

object.X = [object.X X2];

object.VE = [object.VE VE2+nX1*ones(4,nL2)];
