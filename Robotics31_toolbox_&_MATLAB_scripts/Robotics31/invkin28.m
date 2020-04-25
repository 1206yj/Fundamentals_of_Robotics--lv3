function q = invkin28(robot,w)

l1 = robot.L(1).DH(3);
l2 = robot.L(2).DH(3);
c2 = (w(1)^2+w(2)^2-l1^2-l2^2)/(2*l1*l2);
s2 = sqrt(1-c2^2);
q(1) = atan2(w(2),w(1))-atan2(l2*s2,l1+l2*c2);
q(2) = atan2(s2,c2);
q(3) = w(3) - robot.L(2).DH(2) - robot.L(4).DH(2);
q(4) = w(4) - q(1) - q(2);

q = q';