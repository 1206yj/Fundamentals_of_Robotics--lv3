function robot = neinit(robotIn,q)

robot = robotIn;
robot.bInit = 1;

T = eye(4);
R = T(1:3,1:3);

for i = 1:robot.n
    z = R*[0 0 1]';    
    p = T(1:3,4);
    pDH = robot.L(i).DH;
    pDH(2-robot.L(i).ksi) = q(i);
    T = T * dhtransf(pDH);
    R = T(1:3,1:3);    
    ds = T(1:3,4) - p;
    dr = R*robot.L(i).dc;    
    D = R * robot.L(i).Dc * R';    
    robot.L(i).z = z;
    robot.L(i).ds = ds;
    robot.L(i).dr = dr;
    robot.L(i).T = T;
    robot.L(i).D = D;
end

