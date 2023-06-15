%% Input voltages v_i^0 [V]
    det_cramer = det([gamma1*k1 (1-gamma2)*k2; (1-gamma1)*k1 gamma2*k2]);
    v01 = det([a1*sqrt(2*g*h01) (1-gamma2)*k2; a2*sqrt(2*g*h02) gamma2*k2])/det_cramer;
    v02 = det([gamma1*k1 a1*sqrt(2*g*h01); (1-gamma1)*k1 a2*sqrt(2*g*h02)])/det_cramer;  
%% Water levels h_3^0 - h_4^0 [cm]
    h03 = ((1-gamma2)*k2*v02/a3)^2/(2*g); h04 = ((1-gamma1)*k1*v01/a4)^2/(2*g);
%% Concatenate the values
    h0 = [h01; h02; h03; h04]; 
    v0 = [v01; v02];
%% Remark : small differences of values compared to [Johansson, 2000] due to differences in (k1,k2) + approximations in the article