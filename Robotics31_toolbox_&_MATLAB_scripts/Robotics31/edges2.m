function object = edges2(objectIn)

object = objectIn;

APPROXZERO = 1e-6;

[m, nX] = size(object.X);
[m, nS] = size(object.S);

object = edges(object);

[m, nE] = size(object.E);

object.VE = [];

bMesh = 0;

% compute surface normals

if object.dim == 3
    N = [];

    for iS=1:nS
        N = [N cross(object.X(1:3,object.S(2,iS))-object.X(1:3,object.S(1,iS)),...
            object.X(1:3,object.S(3,iS))-object.X(1:3,object.S(1,iS)))];
    end

    N = N ./ ([1 1 1]' * sqrt(sum(N.*N)));
end

% determine visible edges

for iE=1:nE
    if bMesh == 1
        object.VE = [object.VE object.E(:,iE)];
    else
        if(object.E(4,iE) == -1)
            object.VE = [object.VE object.E(:,iE)];
        else
            if object.dim == 3
                if(1.0 - N(:,object.E(3,iE))'*N(:,object.E(4,iE)) > APPROXZERO)
                    object.VE = [object.VE object.E(:,iE)];
                end
            end                
        end
    end
end

    