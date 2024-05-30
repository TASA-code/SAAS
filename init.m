function init()

    clear; %#ok<CLEAR0ARGS>
    close all; clc
    
    %% PRE-STEP:%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %  Get the path of the current directory and construct the path
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    src_path = fullfile(pwd, 'src');
    addpath(genpath(src_path))
    

    %% MODE:%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %  Alter the input txt file in the READ_INPUT to change mode
    %
    %  INPUT:
    %   @MODEL (struct)  -->  1: INPUT_DES.txt      (single quaternion sim.)
    %                         2: INPUT_SIM.txt  (quaternion profile sim.)
    %                         2: INPUT_PROP.txt (trending data sim.)
    %
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    % MAIN

    % MODEL = READ_INPUT('INPUT_SIM.txt')
    MODEL = READ_INPUT('INPUT_DES.txt')
    % MODEL = READ_INPUT('INPUT_PROP.txt')

    SAAS(MODEL);


end
    