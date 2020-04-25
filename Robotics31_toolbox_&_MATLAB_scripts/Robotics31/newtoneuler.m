function u = newtoneuler(robot,q,dq,ddq,Ftool,g)

if robot.bInit == 0
    robot.bInit = 1;
    T = eye(4);
    F = -Ftool(1:3);
    M = -Ftool(4:6);
    v = zeros(3,1);
    dv = -g;
    w = zeros(3,1);
    dw = zeros(3,1);
    dV = [];
    W = [];
    dW = [];

    for i = 1:robot.n
        z = T(1:3,1:3)*[0 0 1]';
        ksi = robot.L(i).ksi;
        dw = dw + ksi*(ddq(i)*z + cross(w,dq(i)*z));
        w = w + ksi*dq(i)*z;
        p = T(1:3,4);
        pDH = robot.L(i).DH;
        pDH(2-ksi) = q(i);        
        T = T * dhtransf(pDH);
        ds = T(1:3,4) - p;
        dv = dv + cross(dw,ds)+cross(w,cross(w,ds))+(1-ksi)*(ddq(i)*z+2*cross(w,dq(i)*z));
        robot.L(i).z = z;    
        W = [W w];
        dW = [dW dw];
        dV = [dV dv];
        robot.L(i).ds = ds;
        robot.L(i).T = T;
    end

    for i = robot.n:-1:1
        z = robot.L(i).z;
        ksi = robot.L(i).ksi;
        dv = dV(:,i);
        w = W(:,i);
        dw = dW(:,i);       
        ds = robot.L(i).ds;
        T = robot.L(i).T;    
        R = T(1:3,1:3);
        dr = R*robot.L(i).dc;        
        Fn = F;
        F = Fn + robot.L(i).m*(dv + cross(dw,dr) + cross(w,cross(w,dr)));
        D = R * robot.L(i).Dc * R';
        M = M + cross(ds + dr, F) - cross(dr,Fn) + D*dw + cross(w, D*w);
        robot.L(i).dr = dr;        
        robot.L(i).D = D;
        u(i) = ksi*M'*z+(1-ksi)*F'*z;
    end

    u = u';
else % robot.bInit == 1
    F = -Ftool(1:3);
    M = -Ftool(4:6);
    v = zeros(3,1);
    dv = -g;
    w = zeros(3,1);
    dw = zeros(3,1);
    dV = [];
    W = [];
    dW = [];
 
    for i = 1:robot.n
        z = robot.L(i).z;
        ksi = robot.L(i).ksi;
        dw = dw + ksi*(ddq(i)*z + cross(w,dq(i)*z));
        w = w + ksi*dq(i)*z;
        ds = robot.L(i).ds;
        dv = dv + cross(dw,ds)+cross(w,cross(w,ds))+(1-ksi)*(ddq(i)*z+2*cross(w,dq(i)*z));
        W = [W w];
        dW = [dW dw];
        dV = [dV dv];
    end

    for i = robot.n:-1:1
        z = robot.L(i).z;
        ksi = robot.L(i).ksi;
        dv = dV(:,i);
        w = W(:,i);
        dw = dW(:,i);       
        ds = robot.L(i).ds;
        T = robot.L(i).T;      
        R = T(1:3,1:3);
        dr = robot.L(i).dr;
        Fn = F;
        F = Fn + robot.L(i).m*(dv + cross(dw,dr) + cross(w,cross(w,dr)));
        D = robot.L(i).D;    
        M = M + cross(ds + dr, F) - cross(dr,Fn) + D*dw + cross(w, D*w);
        u(i) = ksi*M'*z+(1-ksi)*F'*z;
    end

    u = u';    
end
    