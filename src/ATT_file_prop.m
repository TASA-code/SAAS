%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%   SAAS ATT_file_prop.m
%
%   Cooper Chang Chien
%
%   Input:
%     @param sim      :  (struct)  Simulation setups
%     @param model    :  (struct)  Model parameters
%
%
%   Output:
%     Animation of Satellite attitude based on trending data
%       (attitude + groundtrack + eclipse + sun vector) 
%
%
%   Copyright (C) System Engineering (SE), TASA - All Rights Reserved
%
%   This code is provided under the MIT License.
%
%   Written by Cooper Chang Chien <cooper@tasa.org.tw>, January 2024.
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


function [] = ATT_file_prop(sim, model)
    
    Q = model.q_trend_data;

    figure;
    fig1 = subplot(4,4,1:8);
    fig2 = subplot(4,4,9:16);

    subplot(fig1);
    LVLH(1);
    % [bq, bvec] = BLVLH();
    hold on;

    time_text = text('Position', [1.2, 1.6, 0]);


    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %  PRE-STEP #1 : Construct THRUSTER vector
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    [COMP_DIR, COMP_VECTOR] = create_comp(model);


    SUN_VEC = model.sun_data;
    SUN = quiver3(0,0,0,SUN_VEC(1),SUN_VEC(2),SUN_VEC(3),'color','#EDB120', 'LineWidth', 2);


    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %  PRE-STEP #2 : Construct STR vector
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    [STR_LOS, STR] = STR_coverage(sim.flag.view);
    cone_handle = [];

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %  PRE-STEP #3 : Create model
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    vertices = model.CAD.vert;
    faces = model.CAD.faces;
    h_cube = patch('Vertices', vertices, 'Faces', faces, 'FaceColor', '#708090', 'EdgeColor', 'k', 'EdgeAlpha', 1, 'LineWidth', 2);


    for i = 1:length(Q)

        subplot(fig1);

        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %  STEP #1 : Rotate COMP using quaternion
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        update_vector(Q(i,:), COMP_DIR, COMP_VECTOR, 0.5);
        
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %  STEP #2 : Rotate SUN_VECTOR using quaternion
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        SUN_VECTOR(SUN, SUN_VEC(i,:))


        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %  STEP #3 : Rotate STR using quaternion
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        rotated_STR = update_vector(Q(i,:), STR_LOS, STR, 1);
        
        % Create cone for STR FOV
        [x_cone, y_cone, z_cone, M] = plot_cone(rotated_STR(1), rotated_STR(2), rotated_STR(3));

        % Delete previous cone surface if it exists
        if ~isempty(cone_handle)
            delete(cone_handle);
        end
        
        % Plot cone
        cone_handle = surf(x_cone, y_cone, z_cone, 'Parent', hgtransform('Matrix', M), ...
            'LineStyle', 'none', 'FaceColor', 'r', 'EdgeColor', 'none', 'FaceAlpha', 0.1);


        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %  STEP #4 : Rotate TRITON model using quaternion
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        q_temp = quaternion(Q(i,1), Q(i,2), Q(i,3), Q(i,4));
        R = rotmat(q_temp,'point'); 

        center = [0, 0, 0];  % Center of the cube
        cube_vertices = ((R * (vertices' - center') + center'))';
        set(h_cube, 'Vertices', cube_vertices, 'Faces', faces);


        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %  STEP #5 : Rotate Body axis (disable)
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
        % for k = 1:3   
        %     update_vector(Q(i,:), bq(k,:), bvec(k), 0.5);
        % end

        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        set(time_text, 'String', datestr(model.lla_date(i)));

        view([-132.28 20.51])
        grid on; box on;
        axis([-0.8 0.8 -0.8 0.8 -0.8 0.8]);
        pbaspect([4.5 4.5 2])
        set(gca, 'ZDir', 'reverse');
        set(gca, 'YDir', 'reverse');
        xlabel('LVLH.X'); ylabel('LVLH.Y'); zlabel('LVLH.Z');
        title(string)

        if sim.flag.ecl(i) == 1
            colour = 'r';
        else
            colour = 'b';
        end

        subplot(fig2);
        groundtrack(model.lla_data(i,:),colour);
        hold on;

        drawnow;
        
    end
end