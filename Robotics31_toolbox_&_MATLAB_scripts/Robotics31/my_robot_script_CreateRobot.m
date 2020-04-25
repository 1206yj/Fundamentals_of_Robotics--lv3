
%Helper file
% Edited by Denis Lazor


%broj osi robota
robot.n=6;

%tip zgloba 
%(0->translacijski 1->rotacijski)
ksi=[1 1 1 1 1 1];

%kinematicki parametri  q (theta)-parametri zglobova
q=[0 pi/2 pi/2 pi 0 0]; 

d=[0 0 0 84.75 0 27.25];
a=[8.2526 84 27.6 0 0 0];
alpha=[pi/2 0 pi/2 pi/2 -pi/2 0];

robot.g=[0 0 9.81]';
          
DH=[q; d; a; alpha]';

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
          
          
% %The base is defined with respect to L0
% %center of the manipulator base is (-7.6474 0 -38.5)
% Tbase=[1 0 0 -7.6474
%        0 1 0 0
%        0 0 1 -40 
%        0 0 0 1];
%    
% base=cuboid(60.8,60.8,27);
% base.X= Tbase*base.X;



    







