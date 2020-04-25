clear

% robot

robot = createrobot28();

% environment

a = 1;
b = 1;
c = 0.020;
X0A = [a/2 0 -0.3]';
cub = cuboid(a, b, c);

TA0 = tr(X0A(1),X0A(2),X0A(3),0);
cub.X = TA0*cub.X;

env.k = 1e+4;
zeta = sqrt(2)/2;
mmax = 0.4;
%env.b = 2*zeta*sqrt(env.k*mmax);
env.b = 0;
env.N = [0 0 -1]';
env.d = env.N'*(X0A + [0 0 c/2]');
env.object(1) = cub;

% trajectory

q0 = [-80*pi/180 160*pi/180 -0.1 0 0.0]';
dq0 = zeros(4,1);

robot = dirkin(robot, q0);

w0 = [robot.L(robot.n).T(1:3,4); 
    atan2(robot.L(robot.n).T(2,1),robot.L(robot.n).T(1,1))];

Wrd = [w0' 0.5;
    0.400 -0.200 -0.350 0 1.5;
    0.400 0.200 -0.350 0 2.5;
    w0' 3.5]';

[tmp, m] = size(Wrd);

Qrd = [];

d = [q0(robot.n+1) 0.05 0.05 0.0]';

for k = 1:m
    Qrd = [Qrd [invkin28(robot,Wrd(1:4,k)); d(k); Wrd(5,k)]];
end

tu = 0.2;
T = 0.005;
tf = Qrd(6,m)+tu;

[Qr, dQr, ddQr] = linkvadint2(Qrd,tu*ones(1,m),T,[1 1 0 1 0]');

bDer = 0;

% controller

[tmp, kf] = size(Qr);

Dd = [];

for k = 1:20:kf
    robot = dynmodel(robot,Qr(1:4,k),zeros(4,1),zeros(6,1));
    Dd = [Dd [robot.D(1,1) robot.D(2,2) robot.D(3,3) robot.D(4,4)]'];
end

ctrlparam.nStates = 1;
ctrlparam.x0 = 0;
ctrlparam.T = T;

ctrlparam.Dn = diag(mean(Dd'));
ctrlparam.umax = 10000;
ctrlparam.umin = -10000;
ctrlparam.bCartesian = 0;

wn = 20;
zeta = 1;

ctrlparam.KV = 2*zeta*wn*eye(4);
ctrlparam.KP = wn^2*eye(4);

% display 3D scene

plotbox = [-0.1 1 -0.6 0.6 -0.4 0.1];
alpha = 145;
beta = 30;

figure(1)

dyn3dscene(robot, q0, env, plotbox, alpha, beta, 1, 0.001)





