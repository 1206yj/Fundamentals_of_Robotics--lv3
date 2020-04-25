function invT = invtr(T)

invT = [T(1:3,1:3)' -T(1:3,1:3)'*T(1:3,4); 0 0 0 1];
