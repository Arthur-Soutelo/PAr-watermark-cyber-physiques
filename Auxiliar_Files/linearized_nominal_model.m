%% Time constants
T1 = (A1/a1)*sqrt(2*h01/g); T2 = (A2/a2)*sqrt(2*h02/g);
T3 = (A3/a3)*sqrt(2*h03/g); T4 = (A4/a4)*sqrt(2*h04/g);
%% Linearisation at the operations point P
Alin = blkdiag(-1/T1,-1/T2,-1/T3,-1/T4);
Alin(1,3) = A3/(A1*T3); Alin(2,4) = A4/(A2*T4);
Blin  = [gamma1*k1/A1 0; 0 gamma2*k2/A2; ...
    0 (1-gamma2)*k2/A3; (1-gamma1)*k1/A4 0];
Clin = [kc 0 0 0; 0 kc 0 0]; Dlin = zeros(2);
Plin_ss = ss(Alin,Blin,Clin,Dlin); Glin = tf(Plin_ss);
%% Global parameters
n = length(Alin); m = size(Blin,2);
%% New Kalman Adaptation
Plin_ss_un = ss(Alin,[Blin, eye(n)],Clin,[Dlin, zeros(m,n)]); Glin_un = tf(Plin_ss_un);
% Initial point
x0 = -[h01; h02; h03;h04];
%% Discrete-time (New Kalman Adaptation)
Ts = 1;
Pdlin_ss_un = c2d(Plin_ss_un,Ts);
Gdlin_un = tf(Pdlin_ss_un);
Adlin_un = Pdlin_ss_un.A;
Bdlin_un = Pdlin_ss_un.B;
Cdlin_un = Pdlin_ss_un.C;
Ddlin_un = Pdlin_ss_un.D;
%% Discrete-time
Ts = 1;
Pdlin_ss = c2d(Plin_ss,Ts);
Gdlin = tf(Pdlin_ss);
Adlin = Pdlin_ss.A; Bdlin = Pdlin_ss.B; Cdlin = Pdlin_ss.C; Ddlin = Pdlin_ss.D;
% Initial point
xd0 = x0;
%% Lineaire operative point
rlin0 = 10 * ones(m,1);
ulin0 = -inv(Cdlin*inv(Adlin)*Bdlin)*rlin0;
xlin0 = -inv(Adlin)*Bdlin*ulin0;