function robot = dirkin(robotIn,q)

robot = robotIn;

T = eye(4); 

for i = 1:robot.n
    pDH = robot.L(i).DH;
    pDH(2-robot.L(i).ksi) = q(i);
    T = T * dhtransf(pDH);
    robot.L(i).T = T;
end
    
