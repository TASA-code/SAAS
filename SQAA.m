%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%   Satellite Attitude Visualisation/Animation (quaternion)
%
%   Cooper Chang Chien
%
%   I.R.   : 2024.03.12
%   V.2.1  : 2024.03.13
%   V.2.2  : 2024.03.14
%   V.3    : 2024.03.18
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
%     Details in ATT_file_prop.m and ATT_sim.m
%
%
%   Copyright (C) System Engineering (SE), TASA - All Rights Reserved
%
%   This code is provided under the MIT License.
%
%   Written by Cooper Chang Chien <cooper@tasa.org.tw>, January 2024.
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [output, STR_TRACE] = SQAA(Q, component, Flag, other, string, dates)

    if Flag{1,1} == 1 
        if isempty(Q)
            usr_input = input('No quaternion data detected, Define an orbit? (Y/N): ', 's');
            choice = lower(usr_input);
            switch choice
                case 'y'
                    [OE] = getinput();
                    ATT_orbit_wiz(OE, dates);
                    output = [];
                    STR_TRACE = [];
                case 'n'
                    disp('exiting program...');
            end
        else
            ATT_file_prop(Q, Flag{1,2}, Flag{1,3}, other{1,1}, other{1,2}, dates);
            output = [];
            STR_TRACE = [];
        end
        


    else
        % Create Initial State Figure
        initial(Flag{1,2});
        [output, STR_TRACE] = ATT_sim(Q, component, Flag{1,2}, string);

    end

end
