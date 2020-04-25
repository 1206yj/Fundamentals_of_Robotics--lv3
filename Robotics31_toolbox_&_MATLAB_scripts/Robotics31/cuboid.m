function object = cuboid(a, b, c);

object.dim = 3;

object.X= [a b c 2; 
    -a b c 2; 
    -a -b c 2; 
    a -b c 2;
    a b -c 2;
    -a b -c 2;
    -a -b -c 2;
    a -b -c 2]'*0.5;

object.S= [1 2 3;
    1 3 4;
    1 5 6;
    1 6 2;
    2 6 7;
    2 7 3;
    3 7 8;
    3 8 4;
    4 8 5;
    4 5 1;
    5 8 7;
    5 7 6]';

object.E = [];
object.VE = [];