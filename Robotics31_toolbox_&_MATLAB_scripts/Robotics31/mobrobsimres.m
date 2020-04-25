function mobrobsimres(robot,map,x,r,xr,decimation)

[nk, tmp] = size(x);

for k = 1:decimation:nk
    plotmobrob(robot,map,x(k,:),r(k,:))
    
    pause(0.001)
end

hold on

plot(x(:,1),x(:,2),'g')