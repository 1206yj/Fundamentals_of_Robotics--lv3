function planecontact(W, N, d)

nt = length(W);

R = [];

for k = 1:nt
    e = N'* W(:,k) - d;
    if abs(e) < 5
       R = [R W(:,k)];
    end
end

plot3(R(1,:),R(2,:),R(3,:),'.')
axis equal