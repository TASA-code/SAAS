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
    % !NOTE:%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %!  Quaternions here are defined in a specific frame of reference 
    %!  Import LVLH2BODY quaternion 
    %!%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    [~, q_data]          = import('fs7t_SE_SAAS_Q_2024050090000_2024051090000_A.txt',  '%s%f%f%f%f');
    [lla_date, lla_data] = import('fs7t_SE_SAAS_LATLON_2024050090000_2024051090000_A.txt', '%s%f%f');
    [~, sun_data]        = import('fs7t_SE_SAAS_SUN_2024050090000_2024051090000_A.txt',  '%s%f%f%f');
    [~, ecl_data]        = import('fs7t_SE_SAAS_Eclipse_2024050090000_2024051090000_A.txt',  '%s%f');
    [~, ECI_data]        = import('fs7t_SE_SAAS_ECI_2024050090000_2024051090000_A.txt',  '%s%f%f%f');

    
    %% STEP #1:%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %  Flag to decide SQAA mode
    %     @param view --> animate with earth blockage cone
    %                            0 : no cone
    %                            1 : animate with cone
    %     @param prop --> use imported data to animate
    %                            0 : No (use single quaternion)
    %                            1 : Yes, use sets of quaternion
    %     @param ecl  --> determine the status of eclipse
    %                            0 : No eclipse
    %                            1 : Yes, in eclipse
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    sim = {};

    sim.orbit.OE     = [6892 1e-5 97.46 70 0 0];
    sim.orbit.orbit  = 1;
    sim.orbit.period = 2*pi*sqrt((sim.orbit.OE(1)*1000)^3/3.986004418e14);
    sim.orbit.tspan  = [0 sim.orbit.orbit*sim.orbit.period];
    sim.orbit.time   = round(sim.orbit.tspan(2)/64);

    sim.orbit.beta_angle = deg2rad(-30);

    sim.flag.view = 0;
    sim.flag.ecl  = ecl_data;

    
    %% DEFINE MODEL:%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %  Create and Define model parameter
    %
    %  INPUT:
    %   @param Q          -->  (1x4)     Quaternion applied to target vector
    %   @param component  -->  (string)  Component wish to observe
    %
    %  OUTPUT:
    %   THR_TRACE  :  Selected thruster vector trace
    %   STR_TRACE  :  Star Tracker vector trace
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    model = {};
    
    q_data = q_data(2:16:sim.orbit.time*16,1:4);


    model.name      = 'FS9';
    model.CAD.file  = 'fs9.stl';
    % model.CAD.file  = 'fs9.stl';
    model.CG        = [2.7717896e+00  1.8211494e+01  8.9988957e+02]; % (mm)
    [model.CAD.vert, model.CAD.faces] = model_setup(model.CG, model.CAD.file, 0);
    model.ECI_data  = ECI_data;
    model.lla_date  = lla_date;
    model.lla_data  = lla_data;
    model.ecl_data  = ecl_data;
    model.sun_data  = sun_data;
    % model.q_trend_data = q_data;
    
    %! [roll pitch yaw]
    model.q_des_data = euler_to_quaternion([0 0 60]);
    model.q_trend_data = q_design_eval([0, 0], sim.orbit.beta_angle);
    
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    % model.component = {'name', position, offset}

    model.component.STR1 = {'STR1',...
                       [474.918, 479.593, 931.902],... 
                       [473.641, 478.316, 934.298]};

    model.component.STR2 = {'STR2',... 
                       [-486.347, 537.236, 332.014],...
                       [-443.741, 494.732, 411.878]};
        

    model.component.name     = 'test';
    model.component.location = [-0.388, -0.198,-0.01];


    %% MODE:%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %  Run the ATTITUDE_animation function below to view the result
    %
    %  INPUT:
    %   @mode    -->  (int)   1: ATT_sim
    %                         2: ATT_design
    %                         2: ATT_file_prop
    %                         3: ATT_orbit_wiz
    %
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    mode = 1;
    
    % MAIN
    initial_pos(sim, model)
    [~, ~] = SAAS(mode, sim, model);


end
    