function angleOut = normangle(angle)

bNormal = 0;

angleOut = angle;

while bNormal == 0
    if angleOut > pi
        angleOut = angleOut - 2 * pi;
    else
        if angleOut <= -pi
            angleOut = angleOut + 2 * pi;
        else
            bNormal = 1;
        end
    end
end
   