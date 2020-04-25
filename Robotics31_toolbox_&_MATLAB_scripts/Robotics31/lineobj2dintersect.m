function b = lineobj2dintersect(L,object)

[m, nS] = size(object.S);

for iS = 1:nS
    if linetriangleintersect(L,object.X(:,[object.S(:,iS)]))
        b = 1;
        
        return
    end
end

b = 0;

