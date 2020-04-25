function object = edges(objectIn)

object = objectIn;

[m, nS] = size(object.S);

object.E = [];

nE = 0;

for iS=1:nS
    j = 3;    
    for i=1:3        
        e = [object.S(j,iS); object.S(i,iS)];
        bE = 0;
        for iE=1:nE
            if object.E(1,iE) == e(2) && object.E(2,iE) == e(1)
                object.E(4,iE) = iS;
                bE = 1;
                break;
            end
        end
        if bE == 0
            object.E = [object.E [e; iS; -1]];
            nE = nE + 1;
        end
        j = i;
    end
end
