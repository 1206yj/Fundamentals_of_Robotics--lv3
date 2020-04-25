%OSNOVE ROBOTIKE LV3: PLANIRANJE TRAJEKTORIJE

% Edited by Denis Lazor



close all;
clear;
clc;

fprintf("Calculating -->  ");

my_robot_script_CreateRobot;

Wr = [ -19.3474 0 196;
    130 0 130;
    130 0 125;
    130 0 120;
    130 0 115;
    130 0 110;
    130 0 105;
    130 0 100;
    130 0 95;
    130 0 90;
    130 0 85;
    130 0 80;
    130 0 75;
    130 0 70;
    130 2.5 71;
    130 5 72;
    130 10 74;
    130 12.5 76;
    130 15 78;
    130 20 82;
    130 25 86;
    130 28 90;
    130 30 94;
    130 30.5 98;
    130 30.5 102;
    130 30 106;
    130 28 110;
    130 25 114;
    130 20 118;
    130 15 122;
    130 12.5 124;
    130 10 126;
    130 5 128;
    130 2.5 129;
    130 0 130;
    -19.3474 0 196]';

m = length(Wr);

T60(:,:,1) = [1 0 0 Wr(1,1);
    0 1 0 Wr(2,1);
    0 0 1 Wr(3,1);
    0 0 0 1];


% for i = 2:m-1
%     T60(:,:,i) = [0 0 1 Wr(1,i);
%         0 -1 0 Wr(2,i);
%         1 0 0 Wr(3,i);
%         0 0 0 1]; 
% end

for i = 2:m-1
    T60(:,:,i) = [0 0 1 Wr(1,i);
        0 1 0 Wr(2,i);
        -1 0 0 Wr(3,i);
        0 0 0 1];
end

T60(:,:,m) = [1 0 0 Wr(1,m);
    0 1 0 Wr(2,m);
    0 0 1 Wr(3,m);
    0 0 0 1];

Q = [];


for i = 1:m

    if i==1 | i==m
        Q = [Q my_invkin(T60(:,:,i))];
    else
       Q = [Q my_invkin(T60(:,:,i),Q(:,end))];
    end
    [r,n] =size(Q); 
    if i > 1
        for j = 1:6
            if Q(j,i) - Q(j,i-1) > pi
                Q(j,i) = Q(j,i) - 2 * pi;
            else
                if Q(j,i) - Q(j,i-1) < -pi
                   Q(j,i) = Q(j,i) + 2 * pi;
                end
            end
        end
    end
end


Q = [Q; zeros(1, m)];


dqgr = [8 8 8 8 8 8 100]';
ddqgr = [16 16 16 16 16 16 10000]';

[Qc, dQc, ddQc] = hocook(Q, dqgr, ddqgr, 0.002);

nt = length(Qc);

N = [1 0 0]';
d = 130;

W = [];

for k = 1:nt
    robot = dirkin(robot,Qc(1:6,k));
    W = [W robot.L(robot.n).T(1:3,4)];
end

fprintf("\nDone :)");

figure(1)
plot(Qc(8,:)',Qc(1:6,:)')
figure(2)
plot(Qc(8,:)',dQc(1:6,:)')
figure(3)
plot(Qc(8,:)',ddQc(1:6,:)')


figure(4)
dyn3dscene(robot, Qc, [], [-300 400 -300 400 -300 400], 145, 30, 0.05,0.001)

hold on

plot3(W(1,:),W(2,:),W(3,:),'g',Wr(1,:),Wr(2,:),Wr(3,:),'ro'),axis equal

hold off

figure(5)

planecontact(W,N,d)