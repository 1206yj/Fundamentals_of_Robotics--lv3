function robot = createrobot28();

robot.n = 4;

d = 0.040;

rho = 2700;
g = 9.81;

% link 1

robot.L(1).ksi = 1;
l1 = 0.5;
a1 = 0.02;
robot.L(1).DH = [0 0 l1 0]';
robot.L(1).B(1,:) = [-l1/2, 0, 0, l1+a1, a1, a1];
robot.L(1).m = a1^2*(l1+a1)*rho;
robot.L(1).dc = [-l1/2 0 0]';
robot.L(1).Dc = robot.L(1).m / 12 * diag([2*a1^2, (l1+a1)^2+a1^2, a1^2+(l1+a1)^2]);

% link 2

robot.L(2).ksi = 1;
l2 = 0.5;
a2 = 0.02;
a3 = 0.02;
b2 = 0.04;
robot.L(2).DH = [0 -(a1/2+a2/2) l2 0]';
robot.L(2).B = [-l2/2-a2/4-b2/4, 0, 0, l2+a2/2-b2/2, a2, a2;
                0, 0, 0, b2, b2, b2;
                0, 0, 0, a3, a3, b2];
robot.L(2).m = a2^2*(l2+a2)*rho;
robot.L(2).dc = [-l2/2 0 0]';
robot.L(2).Dc = robot.L(2).m / 12 * diag([2*a2^2, (l2+a2)^2+a2^2, a2^2+(l2+a2)^2]);            

% link 3

robot.L(3).ksi = 0;
l3 = 0.3;
robot.L(3).DH = [0 0 0 0]';
robot.L(3).B(1,:) = [0, 0, l3/2, a3, a3, l3];
robot.L(3).m = a3^2*l3*rho;
robot.L(3).dc = [0 0 l3/2]';
robot.L(3).Dc = robot.L(3).m / 12 * diag([l3^2+a3^2, l3^2+a3^2, 2*a3^2]);   

% link 4

robot.L(4).ksi = 1;
a4 = 0.1;
b4 = 0.02;
c4 = 0.04;
d4 = 0.01;
e4 = 0.05;
robot.L(4).DH = [0 -(d4+e4) 0 pi]';
robot.L(4).B = [0, 0, -(d4/2+e4), b4, a4, d4;
                0, d/2+d4/2, -e4/2, c4, d4, e4;
                0, -d/2-d4/2, -e4/2, c4, d4, e4];
robot.L(4).m = a4*b4*d4*rho;
robot.L(4).dc = [-e4-d4/2 0 0]';
robot.L(4).Dc = robot.L(4).m / 12 * diag([a4^2+d4^2, b4^2+d4^2, a4^2+b4^2]);   

%

Ftool = zeros(6,1);

robot.g = [0 0 g]';