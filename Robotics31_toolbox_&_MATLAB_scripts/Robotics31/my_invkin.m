function q = my_invkin(T60, qPrev)

% p(1,2,3) = x ,y ,z koordinata sjecišta zadnja 3 zgloba
p = T60 * [0 0 -27.25 1]';
x=p(1); y=p(2); z=p(3);

Q = [];

%Theta 3
syms u3 'real';
c3 = (1-u3^2)/(1+u3^2);
s3 = 2 * u3 / (1+u3^2);

% Supstitutions (theta 3)
f1 = 84.75*s3 + 27.6*c3 + 84;
f2 = 27.6*s3 - 84.75*c3;
a1 = 8.2526;
L = x^2+y^2+z^2;
t = f1^2+f2^2;    
left = L^2-2*L*a1^2+(4*a1^2*z^2)+a1^4;
right = t*(2*a1^2+2*L)-t^2;
u3 = double(solve(left == right));
real_res_count=(size(u3));
   

for i = 1:real_res_count(1)     %Looping trough number of real solutions for u3 ***Not included in LV2***


       
   theta3 = 2*atan(u3(i));
   


%    if i == 0
%        if theta3 >= 0
%              theta3 = pi - theta3;
%              disp(theta3);
%        else
%             theta3 = -pi - theta3;
%        end
%    end   

        
        for j = 1:2

            % Theta 2
            syms u2 'real';

            c2 = (1-u2^2)/(1+u2^2);
            s2 = 2 * u2 / (1+u2^2);

            s3 = sin(theta3);
            c3 = cos(theta3);

            f1 = 84.75*s3 + 27.6*c3 + 84;
            f2 = 27.6*s3 - 84.75*c3;

            u2=double(solve(z-f1*s2-f2*c2));
            theta2 = 2*atan(u2(j));



            % Theta 1
            syms c1 s1 'real';

            s2 = sin(theta2);
            c2 = cos(theta2);

            g1 = c2*f1 - s2*f2 + a1;    
            eqn = [x == c1*g1, y == s1*g1]; % g2 = 0

            [c,s] = solve(eqn,[c1 s1]);
            c = double(c);
            s = double(s);
            theta1 = atan2(s,c);
    

           

            % Matrices
            T10 = dhtransf([theta1 0 8.2526 pi/2]);
            T21 = dhtransf([theta2 0 84 0]);
            T32 = dhtransf([theta3 0 27.6 pi/2]);       
            T30 = T10*T21*T32;       
            R30 = T30(1:3,1:3);       
            R60 = T60(1:3,1:3);   
            R63 = R30'*R60;
            pao=(T30 * [0 0 84.75 1]')';


            if round(pao(1),10)~=round(x,10) || round(pao(2),10)~=round(y,10)
                continue;
            end

        
                for k = 1:2


                    % Theta 5
                    if k == 1
                        theta5 = acos(R63(3,3));
                    else    
                        theta5 = -acos(R63(3,3));
                    end



                    % Theta 4,6 (depending on theta 5)
                    if sin(theta5) ~= 0
                        theta4 = atan2(-R63(2,3)/sin(theta5),-R63(1,3)/sin(theta5));
                        theta6 = atan2(-R63(3,2)/sin(theta5),R63(3,1)/sin(theta5));
                    elseif cos(theta5) == 1
                        theta4 = 0;
                        theta6 = atan2(R63(2,1),R63(1,1));
                    else
                        theta4 = 0;
                        theta6 = atan2(R63(2,2),R63(1,2));
                    end



                    % Cheking theta 4,5,6
                    c4 = cos(theta4);
                    c5 = cos(theta5);
                    c6 = cos(theta6);
                    s4 = sin(theta4);
                    s5 = sin(theta5);
                    s6 = sin(theta6);

                    R63_ = [c4*c5*c6-s4*s6 -c4*c5*s6-s4*c6 -c4*s5;
                            s4*c5*c6+c4*s6 -s4*c5*s6+c4*c6 -s4*s5;
                            s5*c6 -s5*s6 c5];
                        
                        
                    check = isequal(round(R63,10),round(R63_,10));

                    
                    if check == 0
                        continue;
                    end

                    % Final theta vector(one of solutions) -- q saved only if all
                    % checkups are succesful
                    q = [theta1 theta2 theta3 theta4 theta5 theta6];
                    Q = [Q q'];
                   
                    
                    
          
                end   
         end
end


%Finding optimal result
[m,n] = size(Q);

fprintf("__@'_'");
if nargin == 1
    q = Q(:,6);

else
    dQ = Q-qPrev*ones(1,n);
    
    for i=1:6
        for j=1:n
            if dQ(i,j) > pi
                dQ(i,j) = dQ(i,j) - 2*pi;
            else
                if dQ(i,j) < -pi
                    dQ(i,j) = dQ(i,j) + 2*pi;
                end
            end
        end
    end
    
    [tmp, i] = min(max(abs(dQ)));    
    
    q = qPrev + dQ(:,i);
end


end


