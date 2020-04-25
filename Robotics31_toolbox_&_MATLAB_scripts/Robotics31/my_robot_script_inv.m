%OSNOVE ROBOTIKE LV2: INVERZNA KINEMATIKA

close all;
clear;
clc;

  
%**********Create robot****************************

%broj osi robota
robot.n=6;

%tip zgloba 
%(0->translacijski 1->rotacijski)
ksi=[1 1 1 1 1 1];

% Predmet
% Pozicija i velicina predmeta
ta0 = [50 80 -47.5];
A=20; B=11; C=10; 

% Kut rotacije predmetaa oko z-osi
obj_alpha = 0;

ca = cos(obj_alpha);
sa = sin(obj_alpha);

% kvadar A: dimenzije a x b x c
% matrica transformacije iz koordinatnog sustava 6 u koordinatni sustav A
%(rotacija oko osi z6 za 180 stupnjeva + translacija centar mase po z)
T6A=[1 0 0 0;
      0 -1 0 0;
      0 0 -1 -5;
      0 0 0 1];
  
% Rotacijska matrica objekta s obzirom na bazni kordinatni sustav  
RA0 = [ca -sa 0
       sa ca 0
       0 0 1];
  
% Matrica transformacije iz kordinatnog sustava objekta u bazni koord. sustav   
TA0_ = [RA0,(ta0)'];
TA0 = [TA0_;[0 0 0 1]];

% Matrica transformacije iz kordinatnog sustava 6(alat) u bazni koord. sustav   
T60 = TA0 * T6A;
% disp(T60);
% T60=[1 0 0 19.3474;
%      0 1 0 0;
%      0 0 1 196;
%      0 0 0 1];

%kinematicki parametri  
d=[0 0 0 84.75 0 27.25];
a=[8.2526 84 27.6 0 0 0];
alpha=[pi/2 0 pi/2 pi/2 -pi/2 0];


%q (theta)-parametri zglobova (inv_kin)
q = my_invkin(T60);


DH=[q'; d; a; alpha]';


for i=1:robot.n
    robot.L(i).ksi=ksi(i);
    robot.L(i).DH=DH(i,:);
end

robot.L(1).B=[-8.2526 -20.5 0 45.5 12 45.5
              -22.75 0 0 16.5 29 16.5
              0 0 -7.25 29 29 14.5];
          
robot.L(2).B=[-84 0 7.25 29 29 14.5
              -42 0 7.25 55 29 14.5
              0 0 7.25 29 29 14.5];

robot.L(3).B=[-27.6 -7.25 0 29 14.5 29
              0 0 5.5 26.2 26.2 40
              0 0 50.5 11.4 11.4 50];

robot.L(4).B=[0 -3.25 0 4 12.5 4];

robot.L(5).B=[0 0 6.5 13 13 6.5
              0 -4.25 0 13 4.5 6.5
              0 4.25 0 13 4.5 6.5];

robot.L(6).B=[0 0 -14.450 6.5 6.5 5.5
              0 0 -11.5 6 6 1
              0 0 -10.5 15 15 1
              0 -6 -5 4 1 10
              0 6 -5 4 1 10];


robot.g=[0 0 9.81]';



robmesh = robotmesh(robot, q);

figure;
plot3dobj(robmesh,'b')

%Plot the base of the manipulator
%The base is defined with respect to L0
%center of the manipulator base is (-7.6474 0 -38.5)
Tbase=[1 0 0 -7.6474
       0 1 0 0
       0 0 1 -40 
       0 0 0 1];
   
base=cuboid(60.8,60.8,27);
base.X= Tbase*base.X;
hold on;
plot3dobj(base,'b');

%Adding object to scene
obj=cuboid(A,B,C);
obj.X=TA0*obj.X;
hold on;
plot3dobj(obj,'g');





