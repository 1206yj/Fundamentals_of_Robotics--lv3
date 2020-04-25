function b = circtriangleintersect(X,r,T)

for i = 1:3
    if i == 3
        j = 1;
    else
        j = i + 1;
    end
    
    dXT = T(:,j) - T(:,i);
    NT = [-dXT(2); dXT(1)];
    
    dXTC = X - T(:,i);
    
    q = NT'*dXTC;
    
    if q < 0
        l = sqrt(dXT'*dXT);
        q = q / l;

        if q < -r
            b = 0;
        else
            p = dXT'*dXTC/l;

            if p < 0
                if dXTC'*dXTC <= r^2
                    b = 1;
                else
                    b = 0;
                end
            elseif p > l
                dXTC = X - T(:,j);

                if dXTC'*dXTC <= r^2
                    b = 1;
                else
                    b = 0;
                end
            else
                b = 1;
            end
        end

        return
    end
end

b = 1;

return
    
    
  
      
    