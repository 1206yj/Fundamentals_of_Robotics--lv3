function [XNew, PNew] = ekf(X, P, U, Y, params, bPrediction, bCorrection)

alphae = X(1);
xe = X(2);
ye = X(3);
v = U(1);
w = U(2);

if bPrediction == 1
    % EKF prediction

    cae = cos(alphae);
    sae = sin(alphae);           

    A = [1, 0, 0;
        -params.Ts * v * sae, 1, 0;
        params.Ts * v * cae, 0, 1];

    V = params.Ts * [1, 0;
        0, cae;
        0, sae];

    PPred = A * P * A' + V * params.Rz * V';

    alphaePred = alphae + w*params.Ts;
    cae = cos(alphaePred);
    sae = sin(alphaePred);           
    xePred = xe + v * cae * params.Ts;
    yePred = ye + v * sae * params.Ts;           
else
    alphaePred = alphae;
    xePred = xe;
    yePred = ye;
    PPred = P;
end

% EKF correction                       

alphaeNew = alphaePred;
xeNew = xePred;
yeNew = yePred;
PNew = PPred;

if bCorrection == 1
    for i = 1:params.nM
        if Y(i) >= 0
            cae = cos(alphaeNew);
            sae = sin(alphaeNew);
            Re = [cae -sae; sae cae];
            MCe = Re' * (params.M - [xeNew; yeNew] * ones(1, params.nM));                                        
            Ja = params.f / MCe(1,i) * [MCe(2,i)/MCe(1,i), -1];
            C = Ja * [[-sae cae; -cae -sae] * (params.M(:,i) - [xeNew; yeNew]), -Re'];
            K = PNew * C' / (C * PNew * C' + params.Ru);
            dw = K * (Y(i) - (-params.f * MCe(2,i) ./ MCe(1,i) + params.uc));
            alphaeNew = alphaeNew + dw(1);
            xeNew = xeNew + dw(2);
            yeNew = yeNew + dw(3);
            PNew = (eye(3) - K * C) * PNew;
        end
    end
end  

XNew = [alphaeNew, xeNew, yeNew]';
