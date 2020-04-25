function [U, VE] = project3dscene(scene, TC0, P, gamma)

T0C = invtr(TC0);

[m, nX] = size(scene.X);
[m, nS] = size(scene.S);

% get edges

scene = edges(scene);

[m, nE] = size(scene.E);

% transform vertices from S0 to SC

XC = T0C * scene.X;

XC = XC(1:3,:);

% compute surface normals

N = [];

for iS=1:nS
    N = [N cross(XC(:,scene.S(2,iS))-XC(:,scene.S(1,iS)),...
        XC(:,scene.S(3,iS))-XC(:,scene.S(1,iS)))];
end

N = N ./ ([1 1 1]' * sqrt(sum(N.*N)));

% determine surface visibility

bV = [];

for iS=1:nS
    if(N(:,iS)'*XC(:,scene.S(1,iS)) < 0)
        bV = [bV 1];
    else
        bV = [bV 0];
    end
end

% determine visible edges

VE = [];

cg = cos(gamma);

bMesh = 0;

for iE=1:nE
    if bMesh == 1
        VE = [VE scene.E(:,iE)];
    else
        if(scene.E(4,iE) == -1)
            if(bV(scene.E(3,iE)) == 1)
                VE = [VE scene.E(:,iE)];
            end
        else
            if bV(scene.E(3,iE)) == 1 || bV(scene.E(4,iE)) == 1
                if(bV(scene.E(3,iE)) == 0 || bV(scene.E(4,iE)) == 0)
                    VE = [VE scene.E(:,iE)];
                else
                    if(N(:,scene.E(3,iE))'*N(:,scene.E(4,iE)) < cg)
                        VE = [VE scene.E(:,iE)];
                    end
                end
            end
        end
    end
end
    
U = P * [XC; ones(1, nX)];

U = U(1:2,:) ./ ([1; 1] * U(3,:));