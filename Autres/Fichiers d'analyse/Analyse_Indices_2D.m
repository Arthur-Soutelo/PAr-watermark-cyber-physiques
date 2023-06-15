cd ..; cd ..                % Go back to previous folder
%% >>>>>>>>>> Nombre d'iterations <<<<<<<<<<
nit = 10;
%% >>>>>>>>>> F E N E T R E     T E M P O R E L E <<<<<<<<<<
main

vect_timeWindow = 2 : 50;
% Temps de détection :
t_detec = [];
% Taux de fausse alarme et Taux de non détection :
ti = 600;                                   % Systeme stable à partir de 600
TFA_moy = []; TND_moy = [];
for i=1:length(vect_timeWindow)
    disp("Time: "); disp(i)
    timeWindow = vect_timeWindow(i);        % variable used in Simulink
    seuil_H0 = chi2inv(1-PFA, timeWindow*n_chi2);  % variable used in Simulink
    vect_tdet = []; TND = []; TFA = [];
    for k = 1 : nit
        simOut = sim('Watermark.slx');      % Runs Simulink model
        sortie_chi2 = simOut.Chi2;
        % Temps de détection :
        for j = ta: tsim                    % Counts the number of times the Chi2 output is 1 after the attack
            if sortie_chi2(j) == 1
                vect_tdet(k) = j-ta;
                break
            end
        end
        % Taux de fausse alarme (TFA) et Taux de non détection (TND):
        nFA = 0;
        nND = 0;
        for j = ti: ta                  % TFA % Counts the number of times the Chi2 output is 1 before the attack
            if sortie_chi2(j) == 1
                nFA = nFA + 1;
            end
        end
        TFA(k) = 100 * nFA/(ta-ti+1);           % Probability = Number of occurrences / Population
        for j = ta:  1900               % TND % Counts the number of times the Chi2 output is 0 after the attack 
            if sortie_chi2(j) == 0
                nND = nND + 1;
            end
        end
        TND(k) = 100 * nND/((ta+delay)-ta+1);   % Probability = Number of occurrences / Population
    end
    % Temps de détection :
    t_detec(i) = mean(vect_tdet);
    % Taux de fausse alarme et Taux de non détection :
    TFA_moy(i) = mean(TFA);
    TND_moy(i) = mean(TND);
end
% Temps de détection :
figure
plot(vect_timeWindow,t_detec,'b','linewidth',2);
hold on;
xlabel("Fenetre Temporel [s]");
ylabel("Temps de detection [s]");
% Taux de fausse alarme et Taux de non détection :
figure
plot(vect_timeWindow,TFA_moy,'b','linewidth',2);
hold on;
plot(vect_timeWindow,TND_moy,'r','linewidth',2);
legend("TFA","TND")
xlabel("Fenetre Temporel [s]");
ylabel("Taux [%]");

%% >>>>>>>>>> V A R I A N C E <<<<<<<<<<
main

ti = 600;                           % Systeme stable à partir de 600
vect_varW = 0.1 : 0.025 : 4.5;

% Taux de fausse alarme et Taux de non détection :
TFA_moy = [];
TND_moy = [];
% Temps de détection :
t_detec = [];

for i=1:length(vect_varW)
    disp("Variance: "); disp(i)
    varW = vect_varW(i);
    SigmaW = varW * eye(2);       
    vect_tdet = []; TND = []; TFA = [];
    for k = 1 : nit
        simOut = sim('Watermark.slx');
        sortie_chi2 = simOut.Chi2;
        % Taux de fausse alarme et Taux de non détection :
        nFA = 0;
        nND = 0;
        for j = ti: ta                        % TFA % Counts the number of times the Chi2 output is 1 before the attack
            if sortie_chi2(j) == 1
                nFA = nFA + 1;
            end
        end
        TFA(k) = 100 * nFA/(ta-ti);             % Probability = Number of occurrences / Population
        for j = ta:  1900                     % TND % Counts the number of times the Chi2 output is 0 after the attack 
            if sortie_chi2(j) == 0
                nND = nND + 1;
            end
        end
        TND(k) = 100 * nND/((ta+delay)-ta);     % Probability = Number of occurrences / Population
        % Temps de détection :
        for j = ta: tsim
            if sortie_chi2(j) == 1
                vect_tdet(k) = j-ta;
                break
            end
        end
        
    end
    % Taux de fausse alarme et Taux de non détection :
    TFA_moy(i) = mean(TFA);
    TND_moy(i) = mean(TND);
    % Temps de détection :
    t_detec(i) = mean(vect_tdet);
end
% Taux de fausse alarme et Taux de non détection :
figure
plot(vect_varW,TFA_moy,'b','linewidth',2);
hold on;
plot(vect_varW,TND_moy,'r','linewidth',2);
legend("TFA","TND")
xlabel("Variance");
ylabel("Taux [%]");
% Temps de détection :
figure
plot(vect_varW,t_detec,'b','linewidth',2);
hold on;
xlabel("Variance");
ylabel("Temps de detection [s]");

%% >>>>>>>>>> Analyse J Simulation <<<<<<<<<<
main

ti = 600;                                        % Systeme stable à partir de 600
ta = tsim + 1; attack_DoS = 0; attack_sat = 0; delay = tsim;      % No attack

vect_varW = 0.1 : 0.025 : 4.5;
vect_J = [];
for k=1:length(vect_varW)
    J_sim = [];
    for i=1:nit
        simOut = sim('Watermark.slx');
        sortie_u = simOut.u;
        sortie_h = simOut.h;
        for j=ti:tsim
            s_u = sortie_u(j,:) - v0';
            s_h = sortie_h(j,:) - h0';
            dJ = (s_h * Q * s_h') + (s_u * R * s_u');
        end 
        J_sim(i) = dJ/(tsim-ti);
    end
    vect_J(k) = mean(J_sim);
end

figure
plot(vect_varW,vect_J,'b','linewidth',2);
hold on;
xlabel("Variance");
ylabel("J");

%% >>>>>>>>>> Analyse PFA <<<<<<<<<<
main

ti = 600;                                           % Systeme stable à partir de 500
ta = tsim + 1; attack_DoS = 0; attack_sat = 0; delay = tsim;      % No attack

vect_PFA = [0:0.001:1];
TFA_sim = [];
for k =1: length(vect_PFA)
    disp(k)
    PFA = vect_PFA(k);
    seuil_H0  = chi2inv(1-PFA, n_chi2 * timeWindow);    % variable used in Simulink
    TFA = [];
    for i=1:nit
        simOut = sim('Watermark.slx');
        sortie_chi2 = simOut.Chi2;
        nD = 0;
        for j = ti: tsim   
            if sortie_chi2(j) == 1              % TFA % Counts the number of times the Chi2 output is 1
                nD = nD + 1;
            end
        end
        TFA(i) = 100*nD/(tsim-ti+1);             % Probability = Number of occurrences / Population
    end
    TFA_sim(k) = mean(TFA);
end

figure
plot(100*vect_PFA,TFA_sim,'b','linewidth',2);
hold on;
xlabel("PFA Theorique");
ylabel("PFA Simulation");

%% >>>>>>>>>> Performance Theorique <<<<<<<<<<
Kcalc = P*C' * (C*P*C'+V)^(-1);
J = trace((Q + Adlin'*S*Adlin - S)*(P - Kcalc*C*P)) + trace(S*Q);    % Performance LQG
J_l = J + trace((Bdlin'*S*Bdlin + R)*SigmaW);                          % Performance LQG avec watermark