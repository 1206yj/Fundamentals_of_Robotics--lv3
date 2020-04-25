function robot = jacobian(robotIn,q)

robot = robotIn;

U = eye(4); 
robot.J = [];

for i = robot.n:-1:1
    pDH = robot.L(i).DH;
    pDH(2-robot.L(i).ksi) = q(i);
    U = dhtransf(pDH)*U;
    if robot.L(i).ksi == 1
        V = [U(1,4)*U(2,1)-U(2,4)*U(1,1);
             U(1,4)*U(2,2)-U(2,4)*U(1,2);
             U(1,4)*U(2,3)-U(2,4)*U(1,3);
             U(3,1:3)'];
    else
        V = [U(3,1:3)'; zeros(3,1)];
    end                     
    robot.J = [V robot.J];
end
   
