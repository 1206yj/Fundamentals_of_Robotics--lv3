function  robot = createmobrob()

robot.r = 0.25;
robot.d = 0.4;
robot.rw = 0.1;
robot.Km = 2*2*pi/10;
robot.S = [];
robot.nS = 8;
dphi = pi/(robot.nS-1);

for phi = -pi/2:dphi:pi/2
    robot.S = [robot.S; robot.r * cos(phi), robot.r * sin(phi), phi];
end

robot.S = robot.S';
    
robot.maxr = 2.0;
robot.vardisturb = 0;
robot.varnoise = 0;
robot.TS = 0.05;

robot.camera.f = 300;
robot.camera.w = 320;
robot.camera.uc = robot.camera.w / 2;
robot.camera.stduz = 1;