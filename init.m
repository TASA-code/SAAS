function init()

    clear; %#ok<CLEAR0ARGS>
    close all; clc
    
    %% PRE-STEP #1:%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %  Get the path of the current directory and construct the path
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    src_path = fullfile(pwd, 'src');
    addpath(genpath(src_path))
    
    
    %% PRE-STEP #2:%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %  -> Import on-orbit data from subfolder /data
    %  -> Select orbit propagation time duration by deciding number fo orbits
    %  -> Data pre-processing was done by skipping some points in q_data due to
    %     acquisition frequecy difference (q: 1/64 freq)  
    %  -> Data needed:
    %        1. quaternion
    %        2. Groundtrack (latitude & longitude)
    %        3. Sun vector
    %        4. Eclipse
    %
    %% NOTE:%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %  Quaternions here are defined in a specific frame of reference 
    %  Import LVLH2BODY quaternion 
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    

    [~, q_data]          = import('fs7t_SE_SAAS_Q_2024050090000_2024051090000_A.txt',  '%s%f%f%f%f');
    [lla_date, lla_data] = import('fs7t_SE_SAAS_LATLON_2024050090000_2024051090000_A.txt', '%s%f%f');
    [~, sun_data]        = import('fs7t_SE_SAAS_SUN_2024050090000_2024051090000_A.txt',  '%s%f%f%f');
    [~, ecl_data]        = import('fs7t_SE_SAAS_Eclipse_2024050090000_2024051090000_A.txt',  '%s%f');

    
    
    
    %% STEP #1:%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %  Flag to decide SQAA mode
    %     @param Flag_view --> animate with earth blockage cone
    %                            0 : no cone
    %                            1 : animate with cone
    %     @param Flag_prop --> use imported data to animate
    %                            0 : No (use single quaternion)
    %                            1 : Yes, use sets of quaternion
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    sim = {};

    OE = [6892 1e-5 97.46 340.3470 98.03756 0];


    sim.orbit.OE     = OE;
    sim.orbit.orbit  = 2;
    sim.orbit.period = 2*pi*sqrt((sim.orbit.OE(1)*1000)^3/3.986004418e14);
    sim.orbit.tspan  = [0 sim.orbit.orbit*sim.orbit.period];
    sim.orbit.time   = round(sim.orbit.tspan(2)/64);


    sim.flag.view = 0;
    sim.flag.prop = 1;
    sim.flag.ecl  = ecl_data;

    
    %% DEFINE MODEL:%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %  Run the ATTITUDE_animation function below to view the result
    %
    %  INPUT:
    %   @param Q          -->  (1x4)     Quaternion applied to target vector
    %   @param component  -->  (string)  Component wish to observe
    %
    %  OUTPUT:
    %   THR_TRACE  :  Selected thruster vector trace
    %   STR_TRACE  :  Star Tracker vector trace
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    q_data = q_data(2:16:sim.orbit.time*16,1:4);

    % Create and Define model parameter
    model = {};

    model.name      = 'TRITON';
    model.CAD.path  = '/model/fs9.stl';
    model.CG        = [0.000985  0.0586417  0.494153];
    [model.CAD.vert, model.CAD.faces] = FS9_SAR();
    model.lla_date  = lla_date;
    model.lla_data  = lla_data;
    model.ecl_data  = ecl_data;
    model.sun_data  = sun_data;
    
    model.q_trend_data = q_data;

    % For TRITON, raising, OB1_part
    model.q_des_data = [0.1600 0.7055 0.2057 0.6591];

    model.component.name     = 'OBRCS1';
    model.component.location = [-0.0217171  0.0199314  0.00846277];

    % OBRCS1_location = [-0.0217171 0.0199314 0.00846277];
    % OBRCS2_location = [-0.0237543 -0.0254843 -0.00591477];
    % RCSDM1_location = [0.118926 0.033122 1.19889];



    %% MODE:%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %  Run the ATTITUDE_animation function below to view the result
    %
    %  INPUT:
    %   @mode     -->   1: ATT_sim
    %                   2: ATT_file_prop
    %                   3: ATT_orbit_wiz
    %
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    mode = 3;
    
    % MAIN
    [~, ~] = SAAS(mode, sim, model);



end
    