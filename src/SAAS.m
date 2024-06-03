function SAAS()

    clear; %#ok<CLEAR0ARGS>
    close all; clc
    
    addpath(genpath(pwd))

    %% MODE:%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %  Alter the input txt file in the READ_INPUT to change mode
    %
    %  INPUT:
    %   @MODEL (struct)  -->  1: INPUT_SIM.txt  (single quaternion sim.)
    %                         2: INPUT_PROP.txt  (quaternion profile sim.)
    %
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % MAIN

    MODEL = READ_INPUT('INPUT_SIM.txt');
    structdisp(MODEL)
    
    init(MODEL);

end
    