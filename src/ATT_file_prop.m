%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%   SQAA ATT_prop.m
%
%   Cooper Chang Chien
%
%   Input:
%     @param Q            :  (1x4)     Quaternion applied to target vector
%     @param Flag_View    :  (state)   0: animate without earth view cone
%                                      1: animate with earth view cone
%     @param Flag_Eclipse :  (state)   0: Not Eclipse
%                                      1: Eclipse
%     @param GEO          :  (data)    Ground Track Data
%     @param sun_vec      :  (data)    Sun vector
%
%   Output:
%     animation of vector rotation via single quaternion with satellite model 
%
%
%   Copyright (C) System Engineering (SE), TASA - All Rights Reserved
%
%   This code is provided under the MIT License.
%
%   Written by Cooper Chang Chien <cooper@tasa.org.tw>, January 2024.
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



function [] = ATT_file_prop(Q, Flag_View, Flag_Eclipse, GEO, sun_vec)
    
    figure;
    fig1 = subplot(4,4,1:8);
    fig2 = subplot(4,4,9:16);

    subplot(fig1);
    LVLH(1);
    hold on;
    % [bq, bvec] = BLVLH();

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


    SUN = quiver3(0,0,0,sun_vec(1),sun_vec(2),sun_vec(3),'color','#EDB120', 'LineWidth', 3);


    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %  PRE-STEP #2 : Construct STR vector
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    [STR_LOS, STR] = STR_coverage(Flag_View);
    cone_handle = [];

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %  PRE-STEP #3 : Create simplified TRITON model
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    % Create simplified TRITON model
    [vertices, faces] = TRITON();
    h_cube = patch('Vertices', vertices, 'Faces', faces, 'FaceColor', '#708090', 'EdgeColor', 'k', 'LineWidth', 1.5);


    for i = 1:length(Q)

        subplot(fig1);        
        SUN_VECTOR(SUN, sun_vec(i,:))


        for j = 1:4
            update_vector(Q(i,:), Thruster_q{1,j}, Thruster_v{1,j}, 0.5);
        end
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %  STEP #2 : Rotate STR using quaternion
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

        % Rotate STR vector
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
        %  STEP #3 : Rotate TRITON model using quaternion
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

        % Perform the rotation for TRITON
        q_temp = quaternion(Q(i,1), Q(i,2), Q(i,3), Q(i,4));
        R = rotmat(q_temp,'point'); 

        center = [0, 0, 0];  % Center of the cube
        cube_vertices = ((R * (vertices' - center') + center'))';
        set(h_cube, 'Vertices', cube_vertices, 'Faces', faces);

        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %  STEP #4 : Rotate Body axis (disable)
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
        % for k = 1:3   
        %     update_vector(Q(i,:), bq(k,:), bvec(k), 0.5);
        % end

        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

        view([-132.28 20.51])
        grid on; box on;
        axis([-0.8 0.8 -0.8 0.8 -0.8 0.8]);
        pbaspect([4.5 4.5 2])
        set(gca, 'ZDir', 'reverse');
        set(gca, 'YDir', 'reverse');
        xlabel('LVLH.X'); ylabel('LVLH.Y'); zlabel('LVLH.Z');
        title(string)

        if Flag_Eclipse(i) == 1
            colour = 'r';
        else
            colour = 'b';
        end

        subplot(fig2);
        groundtrack(GEO(i,:),colour);
        hold on;
       
        drawnow;
        
    end
end