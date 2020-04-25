function [H, Phi, Rho, P, V] = hough2(E,U0,dPhi,dRho,wb,nP,wPPhi,wPRho)

[m, n] = size(E);
u0 = U0(1);
v0 = U0(2);

iPhi0 = floor(pi/2/dPhi)+1;
iRho0 = floor(sqrt(n^2+m^2)/2/dRho)+1;
nPhi = 2*iPhi0;
nRho = 2*iRho0;

H = zeros(nRho, nPhi);

CS = [];
SN = [];

for iPhi = 1:nPhi+1
    Phi = (iPhi - iPhi0 - 0.5)*dPhi;
    CS = [CS; cos(Phi)];
    SN = [SN; sin(Phi)];
end
    
for i = wb+1:m-wb
    for j = wb+1:n-wb
        if E(i,j) == 1
            u = j - u0;
            v = i - v0;
            Rho = CS(1)*u+SN(1)*v;
            iRho1 = round(Rho/dRho)+iRho0;
            for iPhi = 1:nPhi
                Rho = CS(iPhi+1)*u+SN(iPhi+1)*v;
                iRho2 = round(Rho/dRho)+iRho0;
                diRho = iRho2-iRho1;
                
                if diRho >= 0                    
                    signdiRho = 1;      
                else
                    signdiRho = -1;
                end
                
                w = 1/(abs(diRho)+1);
                
                if iRho1 < 1
                    iRho1 = 1;
                else
                    if iRho1 > nRho
                        iRho = nRho;
                    end
                end              
                           
                for iRho = iRho1:signdiRho:iRho2
                    H(iRho,iPhi) = H(iRho,iPhi) + w;
                end
                iRho1 = iRho2;
            end
        end
    end
end

Phi = ([1:nPhi]-iPhi0)*dPhi;
Rho = ([1:nRho]-iRho0)*dRho;

H2 = H;
P = [];
V = [];

for iP = 1:nP
    [Y, I] = max(H2);
    [y, iPhiP] = max(Y');
    iRhoP = I(iPhiP);
    P = [P [Phi(iPhiP) Rho(iRhoP)]'];
    
    iPhi1 = iPhiP-wPPhi;
    iPhi2 = iPhiP+wPPhi;
    
    if iPhi1 < 1
        iRho1 = 2*iRho0 - iRhoP - wPRho;
        if iRho1 < 1
            iRho1 = 1;
        end
        iRho2 = 2*iRho0 - iRhoP + wPRho;
        if iRho2 > nRho
            iRho2 = nRho;
        end        
        dRho = iRho2 - iRho1 + 1;
        for iPhi = iPhi1+nPhi:nPhi
            H2(iRho1:iRho2,iPhi) = zeros(dRho,1);
        end
        
        iRho1 = iRhoP - wPRho;
        if iRho1 < 1
            iRho1 = 1;
        end
        iRho2 = iRhoP + wPRho;
        if iRho2 > nRho
            iRho2 = nRho;
        end        
        dRho = iRho2 - iRho1 + 1;
        for iPhi = 1:iPhi2
            H2(iRho1:iRho2,iPhi) = zeros(dRho,1);
        end        
    elseif iPhi2 > nPhi
        iRho1 = iRhoP - wPRho;
        if iRho1 < 1
            iRho1 = 1;
        end
        iRho2 = iRhoP + wPRho;
        if iRho2 > nRho
            iRho2 = nRho;
        end        
        dRho = iRho2 - iRho1 + 1;
        for iPhi = iPhi1:nPhi
            H2(iRho1:iRho2,iPhi) = zeros(dRho,1);
        end         
        
        iRho1 = 2*iRho0 - iRhoP - wPRho;
        if iRho1 < 1
            iRho1 = 1;
        end
        iRho2 = 2*iRho0 - iRhoP + wPRho;
        if iRho2 > nRho
            iRho2 = nRho;
        end        
        dRho = iRho2 - iRho1 + 1;
        for iPhi = 1:iPhi2-nPhi
            H2(iRho1:iRho2,iPhi) = zeros(dRho,1);
        end
    else
        iRho1 = iRhoP - wPRho;
        if iRho1 < 1
            iRho1 = 1;
        end
        iRho2 = iRhoP + wPRho;
        if iRho2 > nRho
            iRho2 = nRho;
        end        
        dRho = iRho2 - iRho1 + 1;
        for iPhi = iPhi1:iPhi2
            H2(iRho1:iRho2,iPhi) = zeros(dRho,1);
        end         
    end
    
    [X1, X2] = cropline(P(1,iP),P(2,iP),n,m,U0);
    
    if ~isempty(X1)
        V = [V [X1; X2]];
    end
end

