function object = cylinder(r, a, n);

object.dim = 3;

object.X = [0 0 0.5*a 1; 0 0 -0.5*a 1]';
    
for i = 0:n-1
    phi = 2*pi/n*i;
    object.X = [object.X [r*cos(phi), r*sin(phi), 0.5*a, 1]' [r*cos(phi), r*sin(phi), -0.5*a, 1]'];
end

object.S = [];

for i = 0:n-2
    j = 2+2*i;
    object.S = [object.S [1 j+1 j+3]' [2 j+4 j+2]' [j+1 j+2 j+4]' [j+1 j+4 j+3]'];
end

j = 2+2*(n-1);

object.S = [object.S [1 j+1 3]' [2 4 j+2]' [j+1 j+2 4]' [j+1 4 3]'];

object.E = [];
object.VE = [];