%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%
%   Satellite Attitude Visualisation/Animation (quaternion)
%
%   Cooper Chang Chien
%
%   I.R.   : 2024.01.20
%   V1.0   : 2024.01.29
%   V1.1   : 2024.02.01
%   V2.0   : 2024.03.06
%   V2.1   : 2024.03.07
%   V2.2   : 2024.03.08
%   V2.2.1 : 2024.03.08
%   V2.3   : 2024.03.08
%   V2.3.1 : 2024.03.11
%   V2.3.2 : 2024.03.12
%
%
%   Input:
%   @param Q            :  (1x4)     Quaternion applied to target vector
%   @param component    :  (string)  Component wish to observe
%   @param flag         :  (state)   0: animate without earth view cone
%                                    1: animate with earth view cone
%   @param string       :  (string)  Vector name 
%
%
%   Output:
%   animation of vector rotation via quaternion with satellite model 
%
%
%   Copyright (C) System Engineering (SE), TASA - All Rights Reserved
%
%   This code is provided under the MIT License.
%
%   Written by Cooper Chang Chien <cooper@tasa.org.tw>, January 2024.
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


function [output, STR_TRACE] = ATT_animation(Q, component, flag, string)
    
    % Create Initial State Figure
    visual(flag);


    % Start animation build-up
    figure;

    LVLH(1);
    hold on;
    quiver3(0,0,0, -1, 0, 0, 'color', "#77AC30", 'LineWidth', 2,'Linestyle',':');
    quiver3(0,0,0, Q(2), Q(3), Q(4), 'color', '#828282', 'LineWidth', 2,'Linestyle',':')
    rotate_quat = quaternion(Q(1), Q(2), Q(3), Q(4));

    % Construct rotated body axis
    [bq, bvec] = BLVLH();


    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %  PRE-STEP #1 : Construct THRUSTER vector
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    [OBRCS1_DIR, OBRCS1_VEC] = OBRCS1();
    [OBRCS2_DIR, OBRCS2_VEC] = OBRCS2();
    [RCSDM1_DIR, RCSDM1_VEC] = RCSDM1();
    [RCSDM2_DIR, RCSDM2_VEC] = RCSDM2();

    % Store Thruster quaternion and vector
    Thruster_q = {OBRCS1_DIR,OBRCS2_DIR,RCSDM1_DIR,RCSDM2_DIR};
    Thruster_v = {OBRCS1_VEC,OBRCS2_VEC,RCSDM1_VEC,RCSDM2_VEC};


    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %  PRE-STEP #2 : Construct STR vector
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    [STR_LOS, STR] = STR_coverage(flag);
    
    cone_handle = [];

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %  PRE-STEP #3 : Create simplified TRITON model
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    % Create simplified TRITON model
    [vertices, faces] = TRITON_model();
    h_cube = patch('Vertices', vertices, 'Faces', faces, 'FaceColor', '#708090', 'EdgeColor', 'k', 'LineWidth', 1.5);

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


    %% Start vector rotation
    % Set up animation parameters
    frames = 20;
    angle_range = 2*acos(Q(1));  % Angle to rotate in radians
    theta = linspace(0, angle_range, frames);
    ax = quaternion(0,0,0,1);
    

    OBRCS1_TRACE = zeros(frames,3);
    OBRCS2_TRACE = zeros(frames,3);
    RCSDM1_TRACE = zeros(frames,3);
    RCSDM2_TRACE = zeros(frames,3);
    STR_TRACE    = zeros(frames,3);


    for frame = 1:length(theta)

        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %  STEP #1 : Rotate Thruster vector using quaternion
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

        % Update quaternion to simulate rotation
        % Slerp function:
        %   1. Interpolates between two quaternions based on the angle between them and the desired interpolation fraction.
        %   2. Ensures constant angular velocity throughout the interpolation, resulting in smooth rotations.
        q_rotation = slerp(ax, rotate_quat, theta(frame)/angle_range);
     
        % Rotate THRUSTER vector
        for i = 1:4
            rotated = q_rotation * Thruster_q{1,i} * conj(q_rotation);
            [~, x1, y1, z1] = parts(rotated);
            plotupdate(Thruster_v{1,i},[x1, y1, z1],0.5);

            switch component
                case 'OBRCS_1'
                    if i == 1
                        OBRCS1_TRACE(frame,:) = [x1, y1, z1];
                        scatter3(x1, y1, z1,'LineWidth',2,'MarkerEdgeColor','k','MarkerFaceColor','b');
                    end
                case 'OBRCS_2'
                    if i == 2
                        OBRCS2_TRACE(frame,:) = [x1, y1, z1];
                        scatter3(x1, y1, z1,'LineWidth',2,'MarkerEdgeColor','k','MarkerFaceColor','b');
                    end
                case 'RCSDM_1'
                    if i == 3
                        RCSDM1_TRACE(frame,:) = [x1, y1, z1];
                        scatter3(x1, y1, z1,'LineWidth',2,'MarkerEdgeColor','k','MarkerFaceColor','r');
                    end
                case 'RCSDM_2'
                    if i == 4
                        RCSDM2_TRACE(frame,:) = [x1, y1, z1];
                        scatter3(x1, y1, z1,'LineWidth',2,'MarkerEdgeColor','k','MarkerFaceColor','r');
                    end
             end
        end
        
        % NOTE: 0.5 is just a factor for visualisation

        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %  STEP #2 : Rotate STR vector and its FOV cone using quaternion
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

        % Rotate STR vector
        rotated_STR = q_rotation * STR_LOS * conj(q_rotation);
        [~, xx, yy, zz] = parts(rotated_STR);
        plotupdate(STR,[xx, yy, zz],1);
        scatter3(xx, yy, zz,'LineWidth',2,'MarkerEdgeColor','k','MarkerFaceColor','#EDB120');
        STR_TRACE(frame,:) = [xx, yy, zz];
        

        % Create cone for STR FOV
        [x_cone, y_cone, z_cone, M] = plot_cone(xx, yy, zz);

        % Delete previous cone surface if it exists
        if ~isempty(cone_handle)
            delete(cone_handle);
        end
        
        % Plot cone
        cone_handle = surf(x_cone, y_cone, z_cone, 'Parent', hgtransform('Matrix', M), ...
            'LineStyle', 'none', 'FaceColor', 'r', 'EdgeColor', 'none', 'FaceAlpha', 0.1);


        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %  STEP #3 : Rotate TRITON model using quaternion
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

        % Perform the rotation for TRITON
        [THE, XX, YY, ZZ] = parts(q_rotation);
        q_temp = quaternion(THE, XX, YY, ZZ);
        R = rotmat(q_temp,'point'); 

        center = [0, 0, 0];  % Center of the cube
        cube_vertices = ((R * (vertices' - center') + center'))';
        set(h_cube, 'Vertices', cube_vertices, 'Faces', faces);

        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %  STEP #4 : Rotate frame of axis
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
        for i = 1:3   
            temp = q_rotation*bq(i)*conj(q_rotation);
            [~, xx1, yy1, zz1] = parts(temp);
            plotupdate(bvec(i),[xx1, yy1, zz1],0.5);
        end

        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

        % Adjust axis limit according to animate option
        view_setting(flag,string);
        drawnow;

    end

    switch component
        case 'OBRCS_1'
            output = OBRCS1_TRACE;
        case 'OBRCS_2'
            output = OBRCS2_TRACE;
        case 'RCSDM_1'
            output = RCSDM1_TRACE;
        case 'RCSDM_2'
            output = RCSDM2_TRACE;
    end
    
    % rotate3d off;
end