function q = trajectory(qStart, qGoal, dqmax, ddq, Ts)

s = abs(qGoal - qStart);

if sqrt(s*ddq) > dqmax
    t1 = dqmax / ddq;
    n1 = floor(t1/Ts);
    s2 = s - ddq*(n1*Ts)^2;
    n2 = ceil(s2/(ddq*Ts^2*n1));
    a = s / (Ts^2*n1*(n1+n2));
else
    n1 = ceil(sqrt(s/(ddq*Ts^2)));
    a = s / (Ts*n1)^2;
    n2 = 0;
end

if qGoal < qStart
    a = -a;
end

v = a*(n1*Ts);
q1 = qStart + 0.5*a*(n1*Ts)^2;

q = [qStart + 0.5*a*[0:n1]'.^2*Ts^2;
    q1+[1:n2]'*v*Ts;
    qGoal-0.5*a*[n1-1:-1:0]'.^2*Ts^2];

    
