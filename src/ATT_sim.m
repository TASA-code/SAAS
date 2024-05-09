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
%   This code is provided under the MIT License.
%
%   Written by Cooper Chang Chien <cooper@tasa.org.tw>, January 2024.
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


function [COMP_TRACE, STR_TRACE] = ATT_sim(sim, model)

    
    Q = model.q_sim_data;

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %  PRE-STEP #0 : Setup frame recording
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    filename = 'output/ATT_sim.mp4';
    writerObj = VideoWriter(filename, 'MPEG-4');
    open(writerObj);


    % Start animation build-up
    figure;

    hold on;
    % quiver3(0,0,0, -1, 0, 0, 'color', "#77AC30", 'LineWidth', 2,'Linestyle',':');
    quiver3(0,0,0, Q(2), Q(3), Q(4), 'color', '#828282', 'LineWidth', 2,'Linestyle',':')
    rotate_quat = quaternion(Q(1), Q(2), Q(3), Q(4));

    % Construct rotated body axis
    LVLH();
    [bq, bvec] = BODY_AXIS();


    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %  PRE-STEP #1 : Construct THRUSTER vector
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    % [COMP_DIR, COMP_VECTOR] = create_comp(model);
    % rot_vec = quiver3(0.198, -0.388, -0.01, -0.388, -0.198,-0.01, "LineWidth",3,'color','b');
    
    % COMP = {};
    % [COMP.START_q, COMP.END_q, COMP.VEC] = create_comp([0.198, -0.388, -0.01], model);
    
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %  PRE-STEP #2 : Construct STR vector
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    [STR1_VEC, STR1_quiver] = STR(sim.flag.view, model.component.STR1);
    cone_handle1 = [];

    [STR2_VEC, STR2_quiver] = STR(sim.flag.view, model.component.STR2);
    cone_handle2 = [];


    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %  PRE-STEP #3 : Create simplified TRITON model
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    vertices = model.CAD.vert;
    faces = model.CAD.faces;
    h_cube = patch('Vertices', vertices, 'Faces', faces, 'FaceColor', '#708090', 'EdgeColor', 'k', 'EdgeAlpha', 0.15, 'LineWidth', 0.5);


    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %  PRE-STEP #4 : Setup animation frame
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    frames = 20;
    angle_range = 2*acos(Q(1));  % Angle to rotate in radians
    theta = linspace(0, angle_range, frames);
    ax = quaternion(1,0,0,0);
    
    STR_TRACE    = zeros(frames,3);
    COMP_TRACE   = zeros(frames,3);



    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %  START SIMULATION
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    for frame = 1:length(theta)

        % Update quaternion to simulate rotation
        % Slerp function:
        %   1. Interpolates between two quaternions based on the angle between them and the desired interpolation fraction.
        %   2. Ensures constant angular velocity throughout the interpolation, resulting in smooth rotations.
        q_temp = slerp(ax, rotate_quat, theta(frame)/angle_range);
        [THETA, X , Y, Z] = parts(q_temp);
        q_rotation = [THETA, X, Y, Z];
     
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %  STEP #1 : Rotate Thruster vector using quaternion
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
        % rotatad_COMP = update_vector(q_rotation, COMP_DIR, COMP_VECTOR, 0.5);
        % COMP_TRACE(frame,:) = [rotatad_COMP(1), rotatad_COMP(2), rotatad_COMP(3)];
        % scatter3(rotatad_COMP(1), rotatad_COMP(2), rotatad_COMP(3),'LineWidth',2,'MarkerEdgeColor','k','MarkerFaceColor','b');

        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %  STEP #2 : Rotate STR vector and its FOV cone using quaternion
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

        [STR_TRACE(frame,:), cone_handle1] = STR_update(q_rotation, STR1_VEC, STR1_quiver, cone_handle1);
        
        [STR_TRACE(frame,:), cone_handle2] = STR_update(q_rotation, STR2_VEC, STR2_quiver, cone_handle2);
        

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
            update_vector(q_rotation, bq(i,:), bvec(i), 0.5);
        end

        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

        % Adjust axis limit according to animate option
        view_setting(sim.flag.view, model.component.name);
        
        temp = getframe(gcf);
        writeVideo(writerObj, temp);
        drawnow;
    end
    close(writerObj)
    disp('Rotation Simulation Completed!')

end