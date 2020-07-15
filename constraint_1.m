function [c,ceq] = constraint_1(x)
%问题1的限制方程
global x0;
global N1;
global m_wet_log;
global target_x;
global alpha;
global dt;
global g;
global y_gs_cot;
global p_cs_cos;
global V_max;
global z0_term_1;
global z0_term_inv_1;
global Tt_max;
global Tt_min;
ceq(1:6) = x(1:6,1)-x0;
ceq(7:9) = x(4:6,N1-1);
ceq(10) = x(11,N1-1);
ceq(11:13) = x(7:9,1)-[x(11,1);0;0];
ceq(14:16) = x(7:9,N1-1)-[0;0;0];
ceq(17) = x(10,1)-m_wet_log;
ceq(18) = x(1,N1-1)-target_x(1);
ceq_i = 19;
c_i = 1;
for i = 1:(N1-1)
    ceq(ceq_i:ceq_i+2) = x(4:6,i+1)-x(4:6,i)-dt*0.5*(x(7:9,i)+2*g+x(7:9,i+1)); ceq_i = ceq_i+3;
    ceq(ceq_i:ceq_i+2) = x(1:3,i+1)-x(1:3,i)-dt*0.5*(x(4:6,i)+x(4:6,i+1)); ceq_i = ceq_i+3;
    ceq(ceq_i) = x(10,i+1)-x(10,i)+alpha*dt*0.5*(x(11,i)+x(11,i+1)); ceq_i = ceq_i+1;
    c(c_i) = norm(x(2:3,i) - y_gs_cot*x(1,i)); c_i = c_i+1;
    c(c_i) = norm(x(4:6,i)) - V_max; c_i = c_i+1;
    c(c_i) = norm(x(7:9,i))-x(11,i); c_i = c_i+1;
    c(c_i) = p_cs_cos*x(11,i)-x(7,i); c_i = c_i+1;
    if i>1
        z0 = z0_term_1(1,i);
        mu_1 = Tt_min*z0_term_inv_1(1,i);
        mu_2 = Tt_max*z0_term_inv_1(1,i);
        c(c_i) = mu_1*(1-(x(10,i)-z0)+(x(10,i)-z0)^2*0.5)-x(11,i); c_i = c_i+1;
        c(c_i) = x(11,i)-mu_2*(1-(x(10,i)-z0)); c_i = c_i+1;
    end
end

