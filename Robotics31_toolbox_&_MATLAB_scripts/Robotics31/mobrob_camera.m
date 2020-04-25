function U = mobrob_camera(robot, w, env);

[tmp, nVE] = size(env.VE);

cs = cos(w(3));
sn = sin(w(3));

RA0 = [cs -sn;
    sn cs];

U = [];

for iL = 1:env.nL
    iXL = env.L(iL);
    XL = env.X(:,iXL);
    bOccluded = 0;
    for iX = 1:nVE
        iX1 = env.VE(1,iX);
        iX2 = env.VE(2,iX);
        if iX1 ~= iXL && iX2 ~= iXL
            M1 = env.X(:,iX1);
            M2 = env.X(:,iX2);
            X = lineintersect(w(1:2),XL,M1,M2);
            if ~isempty(X)
                bOccluded = 1;
                break
            end
        end
    end
    if bOccluded
        U = [U; -1];
    else   
        MC = RA0' * (env.X(iL) - w(1:2));
        u = -robot.camera.f * MC(2) / MC(1) + robot.camera.uc + robot.camera.stduz * randn(1,1);
        
        if u < 0 || u > robot.camera.w
            U = [U; -1];
        else                            
            U = [U; u];
        end
    end
end

