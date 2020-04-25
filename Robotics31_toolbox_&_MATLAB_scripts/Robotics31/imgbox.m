function I = imgbox(X,alpha,a,b,c,f,uc,vc,w,h)

I = ones(h,w) * 0.75;

I = imgaddbox(X,alpha,a,b,c,f,uc,vc,w,h,I);

H = fspecial('gaussian',7,1);

I = imfilter(I,H);

I = I + 0.02 * (2*rand(h,w) - 1);

for v = 1:h
    for u = 1:w
        if I(v,u) > 1;
            I(v,u) = 1;
        elseif I(v,u) < 0
            I(v,u) = 0;
        end
    end
end