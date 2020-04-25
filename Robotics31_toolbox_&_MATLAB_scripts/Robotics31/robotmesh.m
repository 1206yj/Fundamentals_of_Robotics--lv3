function [object, A] = robotmesh(robot,q,ZA)

APPROXZERO = 1e-6;

TL = eye(4);
T = TL;

robot = dirkin(robot,q);

object.dim = 3;
object.X=[];
object.S=[];

for i = 1:robot.n
    [nB, m] = size(robot.L(i).B);
    for j = 1:nB
        object2 = cuboid(robot.L(i).B(j,4),robot.L(i).B(j,5),robot.L(i).B(j,6));
        object2.X = tr(robot.L(i).B(j,1),robot.L(i).B(j,2),robot.L(i).B(j,3),0)*object2.X;
        object2.X = robot.L(i).T*object2.X;
        object = merge3dobjs(object, object2);
    end
end

% joint axes

A = [];

if nargin == 3
    [m, nX] = size(object.X);

    for i = 1:robot.n
        if abs(ZA(1,i) - ZA(2,i)) > APPROXZERO            
            object.X = [object.X robot.L(i).T*[0 0 ZA(1,i) 1; 0 0 ZA(2,i) 1]'];
            A = [A [nX+1; nX+2]];   
            nX = nX + 2;
        end
    end
end
