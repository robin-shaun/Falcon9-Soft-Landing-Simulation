function F = guidance(target_x)
step = 1;
Kx = 0.5;
Kv = 0.8;
global N2 x u z g
while step<N2
    m = exp(z(step));
    thrust = Kx*(target_x(1:3)-x(step+1,1:3))+Kv*(target_x(4:6)-x(step+1,4:6))+u(:,step)*m;
    F_tmp = thrust + m*g;
    F(3) = F_tmp(1);
    F(1:2) = F_tmp(2:3);
end