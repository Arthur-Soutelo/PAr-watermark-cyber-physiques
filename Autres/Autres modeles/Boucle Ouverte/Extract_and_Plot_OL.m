%% Get Result
    %     t_sim  = simOut.tout;
    %% Variables from nonlinear system
    %v1_sim = simOut.v_out.Data(:,1); v2_sim = simOut.v_out.Data(:,2);
    y1_sim = simOut.y_out.Data(:,1); y2_sim = simOut.y_out.Data(:,2);
    h1_sim = simOut.h_out.Data(:,1); h2_sim = simOut.h_out.Data(:,2);   
    h3_sim = simOut.h_out.Data(:,3); h4_sim = simOut.h_out.Data(:,4); 
    %% Variables from continuous-time linearized system
    u1_sim = simOut.u_out.Data(:,1); u2_sim = simOut.u_out.Data(:,2);
    u1_norm = u1_sim + v01; u2_norm = u2_sim + v02; 
    ylin1_sim = simOut.ylin_out.Data(:,1); ylin2_sim = simOut.ylin_out.Data(:,2);
    ylin1_norm = ylin1_sim + kc*h01; ylin2_norm = ylin2_sim + kc*h02; 
    x1_sim = simOut.x_out.Data(:,1); x2_sim = simOut.x_out.Data(:,2);
    x3_sim = simOut.x_out.Data(:,3); x4_sim = simOut.x_out.Data(:,4);
    x1_norm = x1_sim + h01; x2_norm = x2_sim + h02; x3_norm = x3_sim + h03; x4_norm = x4_sim + h04;
    %% Variables from discrete-time linearized system
    ydlin1_sim = simOut.ydlin_out.Data(:,1); ydlin2_sim = simOut.ydlin_out.Data(:,2);
    ydlin1_norm = ydlin1_sim + kc*h01; ydlin2_norm = ydlin2_sim + kc*h02; 
    xd1_sim = simOut.xd_out.Data(:,1); xd2_sim = simOut.xd_out.Data(:,2);
    xd3_sim = simOut.xd_out.Data(:,3); xd4_sim = simOut.xd_out.Data(:,4);
    xd1_norm = xd1_sim + h01; xd2_norm = xd2_sim + h02; xd3_norm = xd3_sim + h03; xd4_norm = xd4_sim + h04;
%% Plot signals of nonlinear model
    %% h1, h2, h3, h4
    figure,
        plot(t_sim,h1_sim,'linewidth',2)
        hold on
        plot(t_sim,h2_sim,'linewidth',2)
        plot(t_sim,h3_sim,'linewidth',2)
        plot(t_sim,h4_sim,'linewidth',2)             
        xlabel('time (s)')
        ylabel('Water level (cm)')
        title('Nonlinear Model')
        legend('h_1','h_2','h_3','h_4')   
        grid on 
    %% y1, y2, r1, r2
    r1_sim = r1*ones(1,tsim+1);
    r2_sim = r2*ones(1,tsim+1);
    figure,
        plot(t_sim,r1_sim,'b--','linewidth',2)
        hold on
        plot(t_sim,r2_sim,'r--','linewidth',2)
        plot(t_sim,y1_sim,'b','linewidth',2)
        plot(t_sim,y2_sim,'r','linewidth',2)             
        xlabel('time (s)')
        ylabel('Output (V)')
        title('Nonlinear Model')
        legend('r_1','r_2','y_1','y_2')   
        grid on 
%% Comparaison with linearized models (continuous- and discrete- time)
    %% h1 (h3), x1 + h01 (x3 + h03), xd1 + h01 (xd3 + h03)
    figure,
        plot(t_sim,h1_sim,'b','linewidth',2)
        hold on
        plot(t_sim,x1_sim+h01,'r','linewidth',2)
        stairs(t_sim,xd1_sim+h01,'m--','linewidth',2)    
        plot(t_sim,h3_sim,'b','linewidth',2)
        plot(t_sim,x3_sim+h03,'r','linewidth',2)
        stairs(t_sim,xd3_sim+h03,'m--','linewidth',2)          
        xlabel('time (s)')
        ylabel('Water level (cm)')
        title('Nonlinear vs Linearized Models')
        legend('h_1/h_3','x_1/x_3','x_{d_1}/x_{d_3}')   
        grid on 
    %% h2 (h4), x2 + h02 (x4 + h04), xd2 + h02 (xd4 + h04)
    figure,
        plot(t_sim,h2_sim,'b','linewidth',2)
        hold on
        plot(t_sim,x2_sim+h02,'r','linewidth',2)
        stairs(t_sim,xd2_sim+h02,'m--','linewidth',2)    
        plot(t_sim,h4_sim,'b','linewidth',2)
        plot(t_sim,x4_sim+h04,'r','linewidth',2)
        stairs(t_sim,xd4_sim+h04,'m--','linewidth',2)          
        xlabel('time (s)')
        ylabel('Water level (cm)')
        title('Nonlinear vs Linearized Models')
        legend('h_2/h_4','x_2/x_4','x_{d_2}/x_{d_4}')   
        grid on   
    %% y1, ylin1 + kc*h01, ydlin1 + kc*h01
    figure,
        plot(t_sim,y1_sim,'b','linewidth',2)
        hold on
        plot(t_sim,ylin1_sim+kc*h01,'r','linewidth',2)
        stairs(t_sim,ydlin1_sim+kc*h01,'m--','linewidth',2)            
        xlabel('time (s)')
        ylabel('Output (V)')
        title('Nonlinear vs Linearized Models')
        legend('y_1','y_{lin_1}','y_{dlin_1}')   
        grid on    
    %% y2, ylin2 + kc*h02, ydlin2 + kc*h02
    figure,
        plot(t_sim,y2_sim,'b','linewidth',2)
        hold on
        plot(t_sim,ylin2_sim+kc*h02,'r','linewidth',2)
        stairs(t_sim,ydlin2_sim+kc*h02,'m--','linewidth',2)            
        xlabel('time (s)')
        ylabel('Output (V)')
        title('Nonlinear vs Linearized Models')
        legend('y_2','y_{lin_2}','y_{dlin_2}')   
        grid on           
   