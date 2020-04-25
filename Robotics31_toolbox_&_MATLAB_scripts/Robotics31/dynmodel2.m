function robot = dynmodel2(robotIn,q,dq,Ftool)

robot = neinit(robotIn,q);

for i = 1:robot.n    
   ddq = zeros(robot.n,1);
   ddq(i) = 1;
   robot.D(:,i) = newtoneuler(robot,q,zeros(robot.n,1),ddq,zeros(6,1),zeros(3,1));
end

robot.N = newtoneuler(robot,q,dq,zeros(robot.n,1),Ftool,robot.g);