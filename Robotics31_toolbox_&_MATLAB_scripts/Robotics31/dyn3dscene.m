% DYN3DSCENE   Displays a dynamic 3D scene.
%    DYN3DSCENE(ROBOT, Q, ENV, PLOTBOX, ALPHA, BETA, T, TPAUSE)
%    Displays an animated 3D scene consisting of a robot and its environment.
%    Robot parameters are stored in ROBOT.
%    The trajectory of the robot is stored in the matrix Q.
%    The parameters of the robot's environment are stored in ENV.
%    PLOTBOX sets the scaling for x y and z axis of the plot.
%    ALPHA and BETA define the viewing angle.
%    T is the sample time for sampling of trajectory.
%    TPAUSE is the time between two consecutive images of the animation.


function dyn3dscene(robot, Qc, env, plotbox0, alpha, beta, T, Tpause)

% scene

%robot = gripper(robot,Qc(robot.n+1,1));
rob = robotmesh(robot,Qc(1:robot.n,1));

scene = rob;

if ~isempty(env)
    nobjs = length(env.object);
    for i = 1:nobjs
        scene = merge3dobjs(scene, env.object(i));
    end
end

scene = edges2(scene);

% display initial scene

%plotview = [145 30];

plot3dobj(scene,'b');
axis equal
axis(plotbox0)  
view([alpha beta])

[m, nc] = size(Qc);

if nc <= 1
    return;
end

pause

% display dynamic scene

%Tview = view;
plotbox = axis;

q = Qc(1:robot.n,:);
t = Qc(robot.n+2,:);
k = 0;

for i = 1:nc    
    if t(i) >= k*T
        k = k+1;
      
        %robot = gripper(robot,Qc(robot.n+1,i));
        rob = robotmesh(robot,q(:,i));
        scene = rob;
        if ~isempty(env)
            nobjs = length(env.object);
            for j = 1:nobjs
                scene = merge3dobjs(scene, env.object(j));
            end
        end
        scene = edges2(scene);
        plot3([scene.X(1,scene.VE(1,:)); scene.X(1,scene.VE(2,:))],...
              [scene.X(2,scene.VE(1,:)); scene.X(2,scene.VE(2,:))],...
              [scene.X(3,scene.VE(1,:)); scene.X(3,scene.VE(2,:))], 'b')
        axis equal
        axis(plotbox) 
        view([alpha beta])
        %view(Tview)
        pause(Tpause)
    end
end