function [Qc, dQc, ddQc] = hocook(Q, dqgr, ddqgr, Ts)

[n, m] = size(Q);

dQ = Q(:,2:m) - Q(:,1:m-1);

dt = [0 sqrt(sum(dQ .* dQ))];

S = 0;

while S < 0.99 | S > 1.01

    t = cumsum(dt);

    M = [3/dt(2)+2/dt(3); 1/dt(3); zeros(m-4,1)];

    for i = 4:m-1
        M = [M [zeros(i-4,1); dt(i); 2*(dt(i-1)+dt(i)); dt(i-1); zeros(m-1-i,1)]];
    end

    M = [M [zeros(m-4,1); 1/dt(m-1); 2/dt(m-1)+3/dt(m)]];

    A = [6/dt(2)^2*(Q(:,2)-Q(:,1))+3/dt(3)^2*(Q(:,3)-Q(:,2))];

    for i = 3:m-2
        A = [A 3/(dt(i)*dt(i+1))*(dt(i)^2*(Q(:,i+1)-Q(:,i))+dt(i+1)^2*(Q(:,i)-Q(:,i-1)))];
    end

    A = [A 3/dt(m-1)^2*(Q(:,m-1)-Q(:,m-2))+6/dt(m)^2*(Q(:,m)-Q(:,m-1))];

    DQ = [zeros(n,1) A*inv(M) zeros(n,1)];

    p0 = Q(:,1);
    p1 = zeros(n,1);
    p2 = zeros(n,1);
    p3 = 4/dt(2)^3*(-Q(:,1)+Q(:,2))-1/dt(2)^2*DQ(:,2);
    p4 = 3/dt(2)^4*(Q(:,1)-Q(:,2))+1/dt(2)^3*DQ(:,2);

    for i = 2:m-2
        p0 = [p0 Q(:,i)];
        p1 = [p1 DQ(:,i)];
        p2 = [p2 3*(Q(:,i+1)-Q(:,i))/(t(i+1)-t(i))^2-(2*DQ(:,i)+DQ(:,i+1))/(t(i+1)-t(i))];
        p3 = [p3 -2*(Q(:,i+1)-Q(:,i))/(t(i+1)-t(i))^3+(DQ(:,i)+DQ(:,i+1))/(t(i+1)-t(i))^2];
        p4 = [p4 zeros(n,1)];
    end

    p0 = [p0 Q(:,m-1)];
    p1 = [p1 DQ(:,m-1)];
    p2 = [p2 6/(t(m)-t(m-1))^2*(-Q(:,m-1)+Q(:,m))-3/(t(m)-t(m-1))*DQ(:,m-1)];
    p3 = [p3 8/(t(m)-t(m-1))^3*(Q(:,m-1)-Q(:,m))+3/(t(m)-t(m-1))^2*DQ(:,m-1)];
    p4 = [p4 3/(t(m)-t(m-1))^4*(-Q(:,m-1)+Q(:,m))-1/(t(m)-t(m-1))^3*DQ(:,m-1)];
    
    Qc = [];
    dQc = [];
    ddQc = [];
    
    for tc = 0:Ts:t(m)
        for i = 2:m
            if tc < t(i)
                break
            end
        end
        i = i-1;
        tcr = tc - t(i);
        Qc = [Qc p0(:,i)+p1(:,i)*tcr+p2(:,i)*tcr^2+p3(:,i)*tcr^3+p4(:,i)*tcr^4];
        dQc = [dQc p1(:,i)+2*p2(:,i)*tcr+3*p3(:,i)*tcr^2+4*p4(:,i)*tcr^3];
        ddQc = [ddQc 2*p2(:,i)+6*p3(:,i)*tcr+12*p4(:,i)*tcr^2];
    end

    tc = [0:Ts:t(m)]';
   
%     figure(1)
%     plot(tc,Qc')
%     figure(2)
%     plot(tc,dQc')
%     figure(3)
%     plot(tc,ddQc')
%     pause 
        
    maxddq = zeros(n,1);
    maxdq = zeros(n,1);
    
    for i = 1:m-1
        ddq = abs(2*p2(:,i));
        j = find(ddq > maxddq);
        maxddq(j) = ddq(j);
        for j = 1:n
            if p4(j,i) ~= 0            
                text = -p3(j,i)/(4*p4(j,i));
                if text > 0 & text <= dt(i+1);
                    ddq = abs(2*p2(j,i)+6*p3(j,i)*text+12*p4(j,i)*text^2);
                    if ddq > maxddq(j)
                        maxddq(j) = ddq;
                    end
                end
            end
        end                
        
        dq = DQ(:,i);
        j = find(dq > maxdq);
        maxdq(j) = dq(j);        
        for j = 1:n
            text = roots([12*p4(j,i) 6*p3(j,i) 2*p2(j,i)]);
            ntext = length(text);
            for k = 1:ntext
                if text(k) > 0 & text(k) <= dt(i+1);
                    dq = abs(p1(j,i)+2*p2(j,i)*text(k)+3*p3(j,i)*text(k)^2+4*p4(j,i)*text(k)^3);
                    if dq > maxdq(j)
                        maxdq(j) = dq;
                    end
                end
            end                
        end
    end
    
    S = max([sqrt(max(maxddq./ddqgr)); max(maxdq./dqgr)]);
    
    dt = dt * S;
end

Qc = [Qc; tc'];
dQc = [dQc; tc'];
ddQc = [ddQc; tc'];


