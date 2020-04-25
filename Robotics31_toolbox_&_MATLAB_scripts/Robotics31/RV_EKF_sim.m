% configuration

if ~exist('multisim')
    multisim = 0;       % 0 - single simulation with animation
                    % 1 - multiple simulations with final result display 
end

if ~exist('camera')
    camera = 1;     % 0 - just prediction step of EKF
                    % 1 - prediction and correction step of EKF
end

if ~exist('rnd')
    rnd = 0;        % 0 - disturbances from workspace
                    % 1 - random disturbances
end

if rnd == 0
    load disturbance
end
 
% parameters

kf = 20 + 10 + 20 + 10 + 4 * 6 + 20;
stdvz = 0.02;
stdwz = 2*pi/180;
stduz = 1;
Ts = 1;
f = 300;
ImageWidth = 320;
cameraRange = 5;
          
if ~exist('nMultiSimulations')
    nMultiSimulations = 1000;
end

% constants

Rz = diag([stdwz^2, stdvz^2]);

Ru = stduz^2;

uc = ImageWidth / 2;

% landmarks

if ~exist('M')
    M = [11, 0;
        9, 6;
        5, 6;
        -3, 2]';
end

nM = max(size(M));

Y = -ones(1,nM);
    
% reference

if ~exist('vr') | ~exist('wr')
    vr = [];
    wr = [];
    L = [20, 10, 20, 10];

    for(i = 1:4)    
        vr = [vr; 0.5 * ones(L(i),1)];
        wr = [wr; zeros(L(i),1)];

        vr = [vr; zeros(6,1)];
        wr = [wr; 15*pi/180 * ones(6,1)];
    end

    vr = [vr; zeros(20,1)];
    wr = [wr; zeros(20,1)];
end

% simulation

if multisim == 0
    nSimulations = 1;
else
    nSimulations = nMultiSimulations;
    Xf = [];
end

v = 0;
w = 0;

for iSimulation = 1:nSimulations
    % disturbances

    if rnd == 1 || multisim == 1
        Z = randn(2+nM, kf);
    end
    
    % initialization

    alpha0 = 0;
    x0 = 0;
    y0 = 0;

    x = x0;
    y = y0;
    alpha = alpha0;
    
    xr = x0;
    yr = y0;
    alphar = alpha0;
    
    xe = x0;
    ye = y0;
    alphae = alpha0;
    P = zeros(3,3);
    
    bCorrection = camera;    
    
    if multisim == 1 & mod(iSimulation, 10) == 0
       display(['simulation ' num2str(iSimulation)])
    end

    % simulation loop
    
    mem = [];
    
    for k = 1:kf
         ca = cos(alpha(k));
         sa = sin(alpha(k));
         
        if bCorrection == 1
            % camera model 

            R = [ca -sa; sa ca];

            MC = R' * (M - [x(k); y(k)] * ones(1, nM));

            Mv = [];
            Y = [];

            for i = 1:nM
                if MC(1,i) > 0.5 && MC(1,i) <= cameraRange
                    Y(i) = -f * MC(2,i) ./ MC(1,i) + uc + stduz * Z(2 + i, k); 
                    if Y(i) >= 0 && Y(i) <= ImageWidth
                        Mv = [Mv, M(:,i)];
                    else
                        Y(i) = -1;
                    end
                else
                    Y(i) = -1;
                end
            end                
        end
            
        % path
         
        alphar(k+1) = normangle(alphar(k) + wr(k)*Ts);
        car = cos(alphar(k+1));
        sar = sin(alphar(k+1));
        xr(k+1) = xr(k) + vr(k) * car * Ts;
        yr(k+1) = yr(k) + vr(k) * sar * Ts;
        
        Xr = [alphar(k+1); xr(k+1); yr(k+1)];
           
        % robot control
        
        [U, X, P, mem] = mobrobctrlalg2(Y, mem, k, Ts, M, Xr, vr(k), wr(k));

        alphae(k) = X(1);
        xe(k) = X(2);
        ye(k) = X(3);
        v(k) = U(1);
        w(k) = U(2);
                  
        if multisim == 0
            % display

            [arrowx, arrowy] = arrow(x(k),y(k),alpha(k),0.4);
            
            [arrowex, arrowey] = arrow(xe(k),ye(k),alphae(k),0.4);

            Pxy = P(2:3,2:3);

            [uncertx, uncerty] = ellipse2(inv(9.21*Pxy), xe(k), ye(k), 0.01);

            if camera == 1 && ~isempty(Mv)
                plot(xe,ye,'ro-', uncertx, uncerty, 'g-', arrowex, arrowey, 'r-',...
                    x,y,'bo-',arrowx, arrowy, 'b-',...
                    xr, yr, 'c-',...
                    M(1,:)',M(2,:)','ko', Mv(1,:)',Mv(2,:)','mo')
            else
                plot(xe,ye,'ro-', uncertx, uncerty, 'g-', arrowex, arrowey, 'r-',...
                    x,y,'bo-',arrowx, arrowy, 'b-',...
                    xr, yr, 'c-',...
                    M(1,:)',M(2,:)','ko')
            end
            
            axis equal
            
            pause(0.5)
        end
            
        %%% state update

        % disturbance

        wz = stdwz * Z(1,k);
        vz = stdvz * Z(2,k);

        % robot motion model

        alpha(k+1) = normangle(alpha(k) + (w(k) + wz)*Ts);
        ca = cos(alpha(k+1));
        sa = sin(alpha(k+1));
        x(k+1) = x(k) + (v(k) + vz) * ca * Ts;
        y(k+1) = y(k) + (v(k) + vz) * sa * Ts;
    end
    
    if multisim == 1
        Xf=[Xf, [x(k+1) y(k+1)]'];
    end
end

if multisim == 1
    plot(Xf(1,:)',Xf(2,:)','b.')
    grid
    xlabel('x')
    ylabel('y')
    axis([-2 11 -4 6])
    axis equal
end