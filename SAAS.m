%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%   Satellite Attitude Animation and Simulation (quaternion)
%   SAAS
%
%   Cooper Chang Chien
%
%   I.R.   : 2024.03.12
%   V.2.1  : 2024.03.13
%   V.2.2  : 2024.03.14
%   V.2.3  : 2024.03.18
%   V.3.0  : 2024.04.17
%   V.3.1  : 2024.04.18
%   V.4.0  : 2024.05.29
%
%   Input:
%
%     @param MODEL         :  (struct)  Model parameters
%
%
%   Output:
%     Details in ATT_sim.m, ATT_file_prop.m, and ATT_design.m
%
%   Copyright (C) System Engineering (SE), TASA - All Rights Reserved
%
%   This code is provided under the Apache License.
%
%   Written by Cooper Chang Chien <cooper@tasa.org.tw>, January 2024.
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function SAAS(MODEL)
    
    switch MODEL.MODE
        case 'simulation'
            ATT_sim(MODEL);

        % case 'design'
        %     ATT_design(MODEL);

        case 'propagation'
            ATT_file_prop(MODEL);

    end

end
