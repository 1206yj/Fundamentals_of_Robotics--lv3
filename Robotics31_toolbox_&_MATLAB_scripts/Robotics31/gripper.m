function robot = gripper(robotIn,d)

robot = robotIn;

[nL, m] = size(robot.L(robot.n).B);

robot.L(robot.n).B(nL-1,2) = 0.5*(robot.L(robot.n).B(nL-1,5)+d);
robot.L(robot.n).B(nL,2) = -0.5*(robot.L(robot.n).B(nL,5)+d);