%% Arthur SOUTELO ARAUJO 
%% Gabriel ROSADO DOS SANTOS MENDES
%% PAr 105 > > > 2022 - 2023
addpath Auxiliar_Files\;    % Add auxiliar files folder to path
%%
%% >>>>>>>>>> Models and Operating point <<<<<<<<<<
%% Non-linear model of the Quadruple-Tank system
nonlinear_model
%% References - Operating point (h0,v0)
% 1) Minimum-phase characteristics
gamma1 = 0.70; 
gamma2 = 0.60;
h01 = 12.4; 
h02 = 12.7;         % [cm]
% 2) Nonminimum-phase characteristics
%     gamma1 = 0.43; gamma2 = 0.34;
%     h01 = 12.6; h02 = 13.0; [cm]

compute_h034_v0                 % Compute h03, h04, v01 and v02
r1 = kc*h01; r2 = kc*h02;       % References
%% Nominal linearization of the Quadruple-Tank system around the operating point (h0,v0)
linearized_nominal_model
%% >>>>>>>>>> Synthesize Kalman Filter and LQG controller <<<<<<<<<<
%% Kalman filter
W = 0.01*eye(n);
V = sigma2_b*eye(m);
[Kkal,L,P] = kalman(Pdlin_ss_un,W,V);
%% LQG controller
Q = blkdiag(50,100,1,1);
R = blkdiag(1,1);
[K,S,~] = dlqr(Adlin,-Bdlin,Q,R);
%% >>>>>>>>>> Synthesize Detecteur Chi 2 <<<<<<<<<<
timeWindow = 7;                          % Taille de la Fenetre Temporelle
PFA = 10^(-10);                          % Probabilité de fausse alarme

n_chi2 = 2;                              % Dimension du residu = 2
seuil_H0  = chi2inv(1-PFA, n_chi2 * timeWindow);    % Seuil de rejet
Sigma = C * P * C' + sigma2_b*eye(m);
SigmaInv = inv(Sigma);
%% >>>>>>>>>> Synthesize Watermarking <<<<<<<<<<
varW = 0.6;                              % Variance du Watermark
mu = 0;                                  % Moyenne du bruit gaussien
SigmaW = varW * eye(2);                  % Matrice de Covariance du Watermark
%% >>>>>>>>>> Simulation <<<<<<<<<<
%% Time parameters
tsim = 2000;                             % Temps de Simulation
t_sim = 0:Ts:tsim;
%%  >>>>>>>>>> Attack parameters <<<<<<<<<<
delay = 700;                             % Time after the atack to Replay
% Attacks :
%ta = tsim + 1; attack_DoS = 0; attack_sat = 0;          % No attack
ta = 0.6*tsim; attack_DoS = 1; attack_sat = 0;          % DoS Attack
% ta = 0.6*tsim; attack_DoS = 0; attack_sat = 1;         % Attack by upper saturation
