function plot3dobj(object,color)

if isempty(object.VE)
    object = edges2(object);
end

plot3([object.X(1,object.VE(1,:)); object.X(1,object.VE(2,:))],... 
      [object.X(2,object.VE(1,:)); object.X(2,object.VE(2,:))],...
      [object.X(3,object.VE(1,:)); object.X(3,object.VE(2,:))], color)
    
axis equal