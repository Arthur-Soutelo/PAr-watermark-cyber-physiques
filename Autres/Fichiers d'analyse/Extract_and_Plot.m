cd ..; cd ..                % Go back to previous folder
%% Get Results
simOut = sim('Watermark.slx',[0:Ts:tsim]);
t_sim  = simOut.tout;
%% Variables from nonlinear system
%     v1_sim = simOut.v_out.Data(:,1); v2_sim = simOut.v_out.Data(:,2);
y1_sim = simOut.y_out.Data(:,1); y2_sim = simOut.y_out.Data(:,2);
h1_sim = simOut.h(:,1); h2_sim = simOut.h(:,2);
h3_sim = simOut.h(:,3); h4_sim = simOut.h(:,4);
%% Sensor noise
b1_sim = simOut.b_out.Data(:,1); b2_sim = simOut.b_out.Data(:,2);
%% Variables from Kalman filter
xKalman1_sim = simOut.xKalman_out.Data(:,1); xKalman2_sim = simOut.xKalman_out.Data(:,2);
xKalman3_sim = simOut.xKalman_out.Data(:,3); xKalman4_sim = simOut.xKalman_out.Data(:,4);
%% Estimative covarariance matrices
%% Estimate covariance matrix of the sensor noise
b_sim = [b1_sim b2_sim];
Vest = b_sim'*b_sim/length(b1_sim);
%% Estimate covariance matrix of the state noise
%     h_sim =  [h1_sim h2_sim h3_sim h4_sim];
%     xKalman_sim = [(xKalman1_sim+h01) (xKalman2_sim+h02) (xKalman3_sim+h03) (xKalman4_sim+h04)];
%     diff = h_sim - xKalman_sim; % mean(diff)
%     West = diff'*diff/length(h1_sim);
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
%% Input v
% figure,
% plot(t_sim,v1_sim,'b--','linewidth',2)
% hold on
% plot(t_sim,v2_sim,'r','linewidth',2)
% xlabel('time (s)')
% ylabel('Input (V)')
% title('Nonlinear Model')
% legend('v_1','v_2')
% grid on
%% Estimation by Kalman
%% h1, xKalman1 + h01
figure,
plot(t_sim,h1_sim,'b','linewidth',2)
hold on
plot(t_sim,xKalman1_sim+h01,'r--','linewidth',2)
plot(t_sim,h3_sim,'b','linewidth',2)
plot(t_sim,xKalman3_sim+h03,'r--','linewidth',2)
xlabel('time (s)')
ylabel('Water level (cm)')
title('True vs Estimated level')
legend('h_1 (h_3)','xhat_1 (xhat_3)')
grid on
%% h2, xKalman2 + h02
figure,
plot(t_sim,h2_sim,'b','linewidth',2)
hold on
plot(t_sim,xKalman2_sim+h02,'r--','linewidth',2)
plot(t_sim,h4_sim,'b','linewidth',2)
plot(t_sim,xKalman4_sim+h04,'r--','linewidth',2)
xlabel('time (s)')
ylabel('Water level (cm)')
title('True vs Estimated level')
legend('h_2 (h_4)','xhat_2 (xhat_4)')
grid on
