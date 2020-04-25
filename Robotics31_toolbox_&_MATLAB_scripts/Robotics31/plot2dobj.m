function plot2dobj(object)

plot([object.X(1,object.VE(1,:)); object.X(1,object.VE(2,:))],...
     [object.X(2,object.VE(1,:)); object.X(2,object.VE(2,:))], 'b')
    
axis equal