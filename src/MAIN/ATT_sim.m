%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%   SAAS ATT_sim.m
%
%   Cooper Chang Chien
%
%   Input:
%     @param sim      :  (struct)  Simulation setups
%     @param model    :  (struct)  Model parameters
%
%
%   Output:
%     Animation on Satellite attitude based on designed
%       quaternion values 
%
%
%   Copyright (C) System Engineering (SE), TASA - All Rights Reserved
%
%   This code is provided under the Apache License.
%
%   Written by Cooper Chang Chien <cooper@tasa.org.tw>, January 2024.
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


function ATT_sim(MODEL)



    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %  PRE-STEP #0 : Setup frame recording
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    filename = 'output/ATT_sim.mp4';
    writerObj = VideoWriter(filename, 'MPEG-4');
    open(writerObj);


    % Start animation build-up
    figure;

    hold on;
    
    if MODEL.VALUE.DESIGN_opt == 0

        if ~isempty(MODEL.VALUE.QUAT_SINGLE)
            Q = MODEL.VALUE.QUAT_SINGLE;
            mode = 'single';
            quiver3(0,0,0, Q(2), Q(3), Q(4), 'color', '#828282', 'LineWidth', 2,'Linestyle',':')
            rotate_quat = quaternion(Q(1), Q(2), Q(3), Q(4));

            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            %  PRE-STEP #4 : Setup animation frame
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            frames = 20;
            angle_range = 2*acos(Q(1));  % Angle to rotate in radians
            theta = linspace(0, angle_range, frames);
            ax = quaternion(1,0,0,0);
            END_SIM = length(theta);

        else
            Q = MODEL.VALUE.QUAT_PROF;
            mode = 'profile';

            END_SIM = length(Q);
        end

    elseif MODEL.VALUE.DESIGN_opt == 1

        mode = 'design';
        BETA_ANGLE = -MODEL.ENV.BETA_ANGLE;
        quiver3(0,0,0,cos(BETA_ANGLE),sin(BETA_ANGLE),0,"LineWidth",3,'color',"#EDB120")

        DESIGN_VAL = MODEL.VALUE.QUAT_DESIGN;
        [Q_ECI, Q_LVLH, energy] = q_design_eval([DESIGN_VAL(1), DESIGN_VAL(2)], BETA_ANGLE, DESIGN_VAL(3));
        [MODEL.RESULT.Q, MODEL.RESULT.Q_LVLH, MODEL.RESULT.ENERGY] = deal(Q_ECI, Q_LVLH, energy);

        if strcmp(MODEL.VALUE.FRAME, 'LVLH')
            Q = Q_LVLH;
        elseif strcmp(MODEL.VALUE.FRAME, 'ECI')
            Q = Q_ECI;
        else
            fprintf('%s\n', 'INVALID FRAME OPTION')
        end

        END_SIM = length(Q);
    end



    % Construct rotated body axis
    LVLH();
    [bq, bvec] = BODY_AXIS();


    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %  PRE-STEP #1 : Construct THRUSTER vector
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    [COMP_VEC, COMP_QUIVER] = create_comp(MODEL);

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %  PRE-STEP #2 : Construct STR vector
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    [STR1_VEC, STR1_quiver] = STR(MODEL.OPTION.STR_VIEW, MODEL.COMPONENT.STR1);
    cone_handle1 = [];

    [STR2_VEC, STR2_quiver] = STR(MODEL.OPTION.STR_VIEW, MODEL.COMPONENT.STR2);
    cone_handle2 = [];


    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %  PRE-STEP #3 : Create simplified model
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    vertices = MODEL.MODEL.CAD.vert;
    faces = MODEL.MODEL.CAD.faces;
    h_cube = patch('Vertices', vertices, 'Faces', faces, 'FaceColor', '#708090', 'EdgeColor', 'k', 'EdgeAlpha', 0.15, 'LineWidth', 0.5);



    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %  START SIMULATION
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    for frame = 1:END_SIM

        if strcmp(mode, 'single')
        % Update quaternion to simulate rotation
        % Slerp function:
        %   1. Interpolates between two quaternions based on the angle between them and the desired interpolation fraction.
        %   2. Ensures constant angular velocity throughout the interpolation, resulting in smooth rotations.
            q_temp = slerp(ax, rotate_quat, theta(frame)/angle_range);
            [THETA, X , Y, Z] = parts(q_temp);
            q_rotation = [THETA, X, Y, Z];

        elseif strcmp(mode, 'profile') || strcmp(mode, 'design')
            q_rotation = Q(frame,:);
            [THETA, X , Y, Z] = deal(Q(frame,1), Q(frame,2), Q(frame,3), Q(frame,4));
        end
     
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %  STEP #1 : Rotate Thruster vector using quaternion
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
        update_vector(q_rotation, COMP_VEC, COMP_QUIVER, 0.5, '');

        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %  STEP #2 : Rotate STR vector and its FOV cone using quaternion
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

        [~, cone_handle1] = STR_update(q_rotation, STR1_VEC, STR1_quiver, cone_handle1);
        
        [~, cone_handle2] = STR_update(q_rotation, STR2_VEC, STR2_quiver, cone_handle2);
        

        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %  STEP #3 : Rotate model using quaternion
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

        % Perform the rotation for TRITON
        q_temp = quaternion(THETA, X, Y, Z);
        R = rotmat(q_temp,'point'); 

        center = [0, 0, 0];  % Center of the cube
        cube_vertices = ((R * (vertices' - center') + center'))';
        set(h_cube, 'Vertices', cube_vertices, 'Faces', faces);


        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %  STEP #4 : Rotate frame of axis
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
        for i = 1:3   
            update_vector(q_rotation, bq(i,:), bvec(i), 0.5,'');
        end

        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

        % Adjust axis limit according to animate option
        view_setting(MODEL.OPTION.STR_VIEW, ' ');
        
        temp = getframe(gcf);
        writeVideo(writerObj, temp);
        drawnow;
    end
    close(writerObj)
    disp('Rotation Simulation Completed!')

end