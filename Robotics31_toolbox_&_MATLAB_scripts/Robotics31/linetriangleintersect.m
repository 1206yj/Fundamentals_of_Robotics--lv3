function b = linetriangleintersect(L,T)

dXL = L(:,2) - L(:,1);
NL = [-dXL(2); dXL(1)];

bCanBeInside = 1;

for i = 1:3
    if i == 3
        j = 1;
    else
        j = i + 1;
    end
    dXT = T(:,j) - T(:,i);
    NT = [-dXT(2); dXT(1)];
    dXTL = L - T(:,i)*[1 1];
    a = dXTL' * NT;
    
    if a(1) < 0 && a(2) < 0
        b = 0;
        
        return;
    elseif a(1) * a(2) < 0
        bCanBeInside = 0;
        
        dXLT = T(:,[j i]) - L(:,1)*[1 1];
        
        c = dXLT' * NL;
        
        if c(1) * c(2) < 0
            b = 1;
            
            return;
        end
    end
end

b = bCanBeInside;
