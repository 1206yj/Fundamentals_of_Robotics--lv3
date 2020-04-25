function I = imgaddbox(X,alpha,a,b,c,f,uc,vc,w,h,Isrc)

I = Isrc;

ca = cos(alpha);
sa = -sin(alpha);

z = X(3)-c;

u0 = f*X(1)/z+uc;
v0 = f*X(2)/z+vc;
d1 = -sa*u0+ca*v0;
d2 = ca*u0+sa*v0;
a2 = f*a/z/2;
b2 = f*b/z/2;

sig = 0.5;

for j = 1:h
    for i = 1:w
        u = i-1;
        v = j-1;
        p1 = -sa*u+ca*v-d1-b2;
        w1 = (tanh(-p1/sig)+1)*0.5;
        p2 = -sa*u+ca*v-d1+b2;
        w2 = (tanh(p2/sig)+1)*0.5;
        p3 = ca*u+sa*v-d2-a2;
        w3 = (tanh(-p3/sig)+1)*0.5;
        p4 = ca*u+sa*v-d2+a2;
        w4 = (tanh(p4/sig)+1)*0.5;
        I(j,i) = I(j,i) - w1*w2*w3*w4*0.5;
    end
end

