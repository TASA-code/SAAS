%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%   Satellite Attitude Animation and Simulator (quaternion)
%
%   Cooper Chang Chien
%
%   I.R.   : 2024.03.12
%   V.2.1  : 2024.03.13
%   V.2.2  : 2024.03.14
%   V.2.3  : 2024.03.18
%   V.3.0  : 2024.04.17
%
%
%   Input:
%     @param Q            :  (1x4)     Quaternion applied to target vector
%     @param component    :  (string)  Component wish to observe
%     @param Flag         :  (1x3)     Flag_prop, Flag_view, Flag_eclipse
%     @param other        :  (1x2)     Ground Track and Sun vector data
%     @param string       :  (string)  Desired plot title 
%
%
%   Output:
%     Details in ATT_sim.m, ATT_file_prop.m, and ATT_orbit_wiz.m
%
%
%   Copyright (C) System Engineering (SE), TASA - All Rights Reserved
%
%   This code is provided under the MIT License.
%
%   Written by Cooper Chang Chien <cooper@tasa.org.tw>, January 2024.
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% function [output, STR_TRACE] = SAAS(Q, component, Flag, other, string, dates)
function [output, STR_TRACE] = SAAS(mode, sim, model)
    
    switch mode
        case 1
            [output, STR_TRACE] = ATT_sim(sim, model);

        case 2
            ATT_file_prop(sim, model);
            output = [];
            STR_TRACE = [];

        case 3
            ATT_orbit_wiz(sim, model);
            output = [];
            STR_TRACE = [];
    end

end
