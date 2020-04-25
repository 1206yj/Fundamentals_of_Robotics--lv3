function F = contactforce(q,dq,robot,env)

if isempty(env) | env.k < 0
    F = zeros(6,1);
else
    robot = dirkin(robot, q);    
    robot = jacobian(robot, q);      
    
    R = robot.L(robot.n).T(1:3,1:3);
    
    w = robot.L(robot.n).T(1:3,4);
    
    J = R * robot.J(1:3,1:robot.n);
    
    dw = J * dq;
    
    s = env.N'*w - env.d;
    ds = env.N'*dw; 
    
    if s > 0
        F = -(env.k * s + env.b * ds)*env.N;
    else
        F = zeros(3,1);
    end
    
    F = [F; zeros(3,1)];
end