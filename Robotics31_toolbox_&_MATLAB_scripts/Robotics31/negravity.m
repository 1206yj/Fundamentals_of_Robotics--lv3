function h = negravity(robot,q)

F=zeros(3,1);
M=zeros(3,1);

for i = robot.n:-1:1
    z = robot.L(i).z;
    ksi = robot.L(i).ksi;
    ds = robot.L(i).ds;
    dr = robot.L(i).dr;
    Fn = F;
    F = Fn - robot.L(i).m*robot.g;
    M = M + cross(ds + dr, F) - cross(dr,Fn);
    h(i) = ksi*M'*z+(1-ksi)*F'*z;
end

h = h';
    