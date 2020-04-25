function [X1, X2]=cropline(phi,d,w,h,U0)

APPROXZERO = 1e-10;

cf = cos(phi);
sf = sin(phi);

i = 1;
mindX2 = (min([w h])*0.5)^2;
u0 = U0(1);
v0 = U0(2);

d2 = d + u0*cf + v0*sf;

if abs(sf) > APPROXZERO
    v = d2/sf;
    if v >= 0 && v <= h - 1;
        X1 = [0 v]';
        i=2;
    end
    v = (d2-cf*(w-1))/sf;
    if v >= 0 && v <= h - 1;
        X = [w-1 v]';
        if(i == 2)
            dX = X - X1;
            if dX'*dX > mindX2
                X2=X;
                return;
            end
        else
            X1=X;
            i = 2;
        end
    end
end

if abs(cf) > APPROXZERO
    u = d2/cf;
    if u >= 0 && u <= w - 1;
        X=[u 0]';
        if(i == 2)
            dX = X - X1;
            if dX'*dX > mindX2
                X2=X;
                return;
            end
        else
            X1=X;
            i = 2;
        end
    end
    u = (d2-sf*(h-1))/cf;
    if u >= 0 && u <= w - 1;
        X=[u h-1]';
        if(i == 2)
            dX = X - X1;
            if dX'*dX > mindX2
                X2=X;
                return;
            end
        else
            X1=X;
            i = 2;
        end
    end
end

X1 = [];
X2 = [];
