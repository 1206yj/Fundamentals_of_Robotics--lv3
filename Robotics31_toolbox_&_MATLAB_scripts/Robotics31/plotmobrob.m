function plotmobrob(robot,map,x,r)

plot2dobj(map);
hold on

[xRob, yRob]=ellipse2(1/robot.r^2*eye(2), x(1), x(2), 0.05);
USA = [cos(robot.S(3,:)); sin(robot.S(3,:))];
SA = robot.S(1:2,:) + USA .* ([1; 1] * r);

cs = cos(x(3));
sn = sin(x(3));

RA0 = [cs -sn;
    sn cs];

S = RA0 * SA + x(1:2)' * ones(1,robot.nS);

C = [];

for iS = 1:robot.nS
    if r(iS) >= 0
        C = [C, S(:,iS)];
    end
end

plot(xRob, yRob, 'r',...
    [x(1); x(1)+robot.r*cos(x(3))], [x(2); x(2)+robot.r*sin(x(3))], 'r')

if ~isempty(C)
    plot(C(1,:)', C(2,:)', 'og');
end

hold off


