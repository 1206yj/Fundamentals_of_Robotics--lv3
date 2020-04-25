function object = merge3dobjs(object1, object2)

[m, nX1] = size(object1.X);
[m, nS2] = size(object2.S);

object.dim = 3;
object.X = [object1.X object2.X];
object.S = [object1.S object2.S+nX1*ones(3,nS2)];
object.E = [];
object.VE = [];