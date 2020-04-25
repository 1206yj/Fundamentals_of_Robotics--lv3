function X = lineintersect(X11, X12, X21, X22)

dX1 = X12 - X11;
l1 = sqrt(dX1'*dX1);
U1 = dX1/l1;
N1 = [-U1(2); U1(1)];
V1 = X21 - X11;
V2 = X22 - X11;
P1(2) = N1' * V1;
P2(2) = N1' * V2;

if P1(2) * P2(2) > 0
    X = [];
    
    return
end

P1(1) = U1' * V1;
P2(1) = U1' * V2;

p = -(P2(1) - P1(1)) / (P2(2) - P1(2)) * P1(2) + P1(1);

if p < 0
    X = [];
    
    return
end

if p > l1
    X = [];
    
    return
end

X = p * U1;


