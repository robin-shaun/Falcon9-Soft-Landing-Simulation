% global N1;
% opt_1 = fmincon(obj_fun_1,zeros(11,N1),[],[],[],[],constraint_1);
% thrust = opt_1;
global x0 target_pos;
global N1 N2;
global m_wet_log;
global alpha;
global dt;
global g;
global y_gs_cot p_cs_cos;
global V_max;
global z0_term_log_1 z0_term_inv_1;
global Tt_max Tt_min;
cvx_begin quiet
    variable x(6,N1)
    variable u(3,N1)
    variable z(1,N1)
    variable s(1,N1)
    obj = 0;
    for i = 1:N1
        obj = obj + norm(x(1:3,i))*i/N1;
    end
    minimize( obj )
    subject to
        x(:,1) == x0
        x(4:6,N1)== [0,0,0]'
        s(1,N1) == 0
        u(:,1) == s(1,1)*[1,0,0]'
        u(:,N1) == [0,0,0]'
        z(1,1) == m_wet_log
        x(1,N1) == target_pos(1)
        for i = 1:(N1-1)
            x(4:6,i+1) == x(4:6,i)+dt*0.5*(u(:,i)+2*g+u(:,i+1))
            x(1:3,i+1) == x(1:3,i)+dt*0.5*(x(4:6,i+1)+x(4:6,i))
            z(1,i+1) == z(1,i) - alpha*dt*0.5*(s(1,i) + s(1,i+1))
            norm(u(:,i)) <= s(1,i)
            u(1,i) >= p_cs_cos*s(1,i)
            if i>1
                z0 = z0_term_log_1(i);
                mu_1 = Tt_min*(z0_term_inv_1(1,i));
                mu_2 = Tt_max*(z0_term_inv_1(1,i));
                s(1,i) >= mu_1*(1-(z(1,i)-z0)+(z(1,i) - z0)^2*0.5) 
                s(1,i) <= mu_2*(1-(z(1,i)-z0))
            end
        end
cvx_end

for i = 1:N1
    if norm(x(:,i))<0.1
        target_pos = x(1:3,i)
        tf = i*dt
        break
    end
end

dt = tf/N2;

cvx_begin quiet
    variable x(6,N2)
    variable u(3,N2)
    variable z(1,N2)
    variable s(1,N2)
    obj = -z(1,N2-1);
    minimize( obj )
    subject to
        x(:,1) == x0
        x(4:6,N2)== [0,0,0]'
        s(1,N2) == 0
        u(:,1) == s(1,1)*[1,0,0]'
        u(:,N2) == [0,0,0]'
        z(1,1) == m_wet_log
        x(1:3,N2) == target_pos
        for i = 1:(N2-1)
            x(4:6,i+1) == x(4:6,i)+dt*0.5*(u(:,i)+2*g+u(:,i+1))
            x(1:3,i+1) == x(1:3,i)+dt*0.5*(x(4:6,i+1)+x(4:6,i))
            z(1,i+1) == z(1,i) - alpha*dt*0.5*(s(1,i) + s(1,i+1))
            norm(u(:,i)) <= s(1,i)
            u(1,i) >= p_cs_cos*s(1,i)
            if i>1
                z0 = z0_term_log_1(i);
                mu_1 = Tt_min*(z0_term_inv_1(1,i));
                mu_2 = Tt_max*(z0_term_inv_1(1,i));
                s(1,i) >= mu_1*(1-(z(1,i)-z0)+(z(1,i) - z0)^2*0.5) 
                s(1,i) <= mu_2*(1-(z(1,i)-z0))
            end
        end
cvx_end

