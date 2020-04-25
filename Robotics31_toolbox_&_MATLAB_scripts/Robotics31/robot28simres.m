W = [];
Wr = [];

nt = length(t);

for k = 1:nt
    robot = dirkin(robot,q(k,:)');
    W = [W robot.L(robot.n).T(1:3,4)];
    robot = dirkin(robot,qr(k,:)');
    Wr = [Wr robot.L(robot.n).T(1:3,4)];    
end

figure(1)

hold off

dyn3dscene(robot, [q'; d'; t'], env, plotbox, alpha, beta,0.05,0.001)

hold on

plot3(Wrd(1,1:m)',Wrd(2,1:m)',Wrd(3,1:m)','ro',...
    Wr(1,1:kf)',Wr(2,1:kf)',Wr(3,1:kf)','r',...
    W(1,:)',W(2,:)',W(3,:),'g');

hold off
