%% General process parameters
% Cross-section Ai [cm2]
A1 = 28; A3 = A1; A2 = 32; A4 = A2;
% Cross-section of the outlet hole ai [cm2]
a1 = 0.071; a3 = a1; a2 = 0.057; a4 = a2;
% Level measurement parameter kc [V/cm]
kc = 0.50;
% Measurement matrix
C = [kc 0 0 0; 0 kc 0 0];
% Accelaration of gravity g [cm/s2]
g = 981;
% Inputs parameter ki [cm3/Vs]
k1 = 3.33; k2 = k1;
%% Saturation of the water levels h1, h2, h3, h4
sat_hmin = 0; sat_hmax = 20;
%% Actuator limitations
sat_vmin = 0; sat_vmax = 12;
%% Define variance of white Gaussian noise
sigma2_b = 0.001;
