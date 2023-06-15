cd ..; cd ..                % Go back to previous folder
%% >>>>>>>>>> Nombre d'iterations  <<<<<<<<<<
nit = 10;

%% >>>>>>>>>> A N A L Y S E     3 D <<<<<<<<<<
main

vect_varW = 0.1 : 0.15 : 3.5;
vect_timeWindow = 2 : 50;

ti = 600;                            % Systeme stable à partir de 600
TFA_moy = []; TND_moy = []; t_detec = []; vect_J = [];
for v=1:length(vect_varW)
    varW = vect_varW(v); 
    SigmaW = varW * eye(2);                                 % variable used in Simulink
    for i=1:length(vect_timeWindow)
        TFA = []; TND = []; vect_tdet = [];
        disp("v , i : "); disp([v,i])
        timeWindow = vect_timeWindow(i);                    % variable used in Simulink
        seuil_H0  = chi2inv(1-PFA, n_chi2 * timeWindow);    % variable used in Simulink
        for k = 1 : nit
            ta = 0.6*tsim; attack_DoS = 1; attack_sat = 0;  % variable used in Simulink
            simOut = sim('Watermark.slx');
            sortie_chi2 = simOut.Chi2;
            
            % Taux de fausse alarme et Taux de non détection :
            nFA = 0;
            nND = 0;
            for j = ti: ta                      % TFA % Counts the number of times the Chi2 output is 1 before the attack
                if sortie_chi2(j) == 1
                    nFA = nFA + 1;
                end
            end
            TFA(k) = 100 * nFA/(ta-ti);         % Probability = Number of occurrences / Population
            for j = ta:  1900                   % TND % Counts the number of times the Chi2 output is 0 after the attack 
                if sortie_chi2(j) == 0
                    nND = nND + 1;
                end
            end
            TND(k) = 100 * nND/((ta+delay)-ta); % Probability = Number of occurrences / Population
            % Temps de détection :
            for j = ta: tsim                    % Counts the number of times the Chi2 output is 1 after the attack
                if sortie_chi2(j) == 1
                    vect_tdet(k) = j-ta;
                    break
                end
            end
            % Analyse J
%             ta = tsim + 1; attack_DoS = 0; attack_sat = 0; delay = tsim;     % No attack
%             simOut = sim('Watermark.slx');
%             sortie_u = simOut.u;
%             sortie_h = simOut.h;
%             dJ = 0;
%             for j=ti:tsim
%                 s_u = sortie_u(j,:) - v0';
%                 s_h = sortie_h(j,:) - h0';
%                 dJ = dJ + (s_h * Q * s_h') + (s_u * R * s_u');
%             end 
%             J_sim(k) = dJ/(tsim-ti+1);
            
        end
        TFA_moy(v,i) = mean(TFA);
        TND_moy(v,i) = mean(TND);
        t_detec(v,i) = mean(vect_tdet);
%         vect_J(v,i) = mean(J_sim);
    end
end

%% Taux de fausse alarme et Taux de non détection
figure
surf(vect_timeWindow,vect_varW,TFA_moy(:,:),"FaceAlpha",0.5);
hold on;
surf(vect_timeWindow,vect_varW,TND_moy(:,:));
colorbar
ylabel("Variance");
xlabel("Fenetre Temporel [s]");
zlabel("Taux");
legend("Fausse Alarme","Non Détection");

%% Intersection Taux de fausse alarme et Taux de non détection
difference = TND_moy(:,:)-TFA_moy(:,:);

figure;
contour(vect_timeWindow,vect_varW,dif(:,:),[0 0],'r','linewidth',2);
ylabel("Variance");
xlabel("Fenetre Temporel [s]");

%% Taux de fausse alarme
figure
surf(vect_timeWindow,vect_varW,TFA_moy(:,:));
colorbar
ylabel("Variance");
xlabel("Fenetre Temporel [s]");
zlabel("Taux");

figure
heatmap(vect_timeWindow,vect_varW,TFA_moy(:,:));
colorbar
ylabel("Variance");
xlabel("Fenetre Temporel [s]");

%% Taux de non détection
figure
surf(vect_timeWindow,vect_varW,TND_moy(:,:));
colorbar
ylabel("Variance");
xlabel("Fenetre Temporel [s]");
zlabel("Taux");

figure
heatmap(vect_timeWindow,vect_varW,TND_moy(:,:));
colorbar
ylabel("Variance");
xlabel("Fenetre Temporel [s]");

%% Temps de détection
figure
surf(vect_timeWindow,vect_varW,t_detec(:,:));
colormap default;
colorbar;
% clim([0 50]);
zlim([-inf 35]);
hold on;
ylabel("Variance");
xlabel("Fenetre Temporel [s]");
zlabel("Temps de Détection [s]");
% colormapeditor

figure
heatmap(vect_timeWindow,vect_varW,t_detec(:,:));
% clim([-inf 50]);
ylabel("Variance");
xlabel("Fenetre Temporel [s]");
% colormapeditor

%% Analyse J
% figure
% surf(vect_timeWindow,vect_varW,vect_J(:,:));
% hold on;
% ylabel("Variance");
% xlabel("Fenetre Temporel [s]");
% zlabel("J");
% 
% figure
% heatmap(vect_timeWindow,vect_varW,vect_J(:,:));
% ylabel("Variance");
% xlabel("Fenetre Temporel [s]");