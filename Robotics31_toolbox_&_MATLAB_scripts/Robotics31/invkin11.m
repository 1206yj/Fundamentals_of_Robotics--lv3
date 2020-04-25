function [q1, q2] = invkin11(l1,l2,w)

c2 = (w(1)^2+w(2)^2-l1^2-l2^2)/(2*l1*l2);
s2 = sqrt(1-c2^2);
q1(1) = atan2(w(2),w(1))-atan2(l2*s2,l1+l2*c2);
q1(2) = atan2(s2,c2);

q1 = q1';

s2 = -sqrt(1-c2^2);
q2(1) = atan2(w(2),w(1))-atan2(l2*s2,l1+l2*c2);
q2(2) = atan2(s2,c2);

q2 = q2';
