function r = ultrasonic(robot, w, env);

[tmp, nVE] = size(env.VE);

cs = cos(w(3));
sn = sin(w(3));

RA0 = [cs -sn;
    sn cs];

r = [];

for iS = 1:robot.nS
    phi = robot.S(3,iS);
    USA = [cos(phi); sin(phi)];
    SA1 = robot.S(1:2,iS);
    SA2 = SA1 + robot.maxr * USA;
    S1 = RA0 * SA1 + w(1:2);
    S2 = RA0 * SA2 + w(1:2);
    US = RA0 * USA;
    maxr = -1;
    for iX = 1:nVE
        M1 = env.X(:,env.VE(1,iX));
        M2 = env.X(:,env.VE(2,iX));
        X = lineintersect(S1,S2,M1,M2);
        if ~isempty(X)
            rS = US' * X;
            if maxr < 0 || rS < maxr
                maxr = rS;
            end                                
        end
    end
    r = [r; maxr];        
end

