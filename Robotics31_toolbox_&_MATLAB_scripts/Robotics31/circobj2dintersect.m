function b = circobj2dintersect(X,r,object)

[m, nS] = size(object.S);

for iS = 1:nS
    if circtriangleintersect(X,r,object.X(:,[object.S(:,iS)]))
        b = 1;
        
        return
    end
end

b = 0;

