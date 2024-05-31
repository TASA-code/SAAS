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


function ATT_file_prop(MODEL)

    
    Q = MODEL.TREND.QUAT;

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %  PRE-STEP #0 : Setup frame recording
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    filename = 'output/ATT_trend.mp4';
    writerObj = VideoWriter(filename, 'MPEG-4');
    open(writerObj);


    figure;
    fig1 = subplot(4,4,[1 2 5 6 9 10 13 14]);
    fig2 = subplot(4,4,[3 4 7 8]);
    fig3 = subplot(4,4,[11 12 15 16]);

    subplot(fig1);
 
    % [bq, bvec] = BLVLH();
    hold on;
    LVLH();

    time_text = text('Position', [0.164,0.866,-1.375]);


    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %  PRE-STEP #1 : Construct THRUSTER vector
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    % [COMP_DIR, COMP_VECTOR] = create_comp([0,0,0], model);


    SUN_VEC = MODEL.TREND.SUN;
    SUN = quiver3(0,0,0,SUN_VEC(1),SUN_VEC(2),SUN_VEC(3),'color','#EDB120', 'LineWidth', 2);


    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %  PRE-STEP #2 : Construct STR vector
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    [STR1_VEC, STR1_quiver] = STR(MODEL.OPTION.STR_VIEW, MODEL.COMPONENT.STR1);
    cone_handle1 = [];

    [STR2_VEC, STR2_quiver] = STR(MODEL.OPTION.STR_VIEW, MODEL.COMPONENT.STR2);
    cone_handle2 = [];

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %  PRE-STEP #3 : Create model
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    vertices = MODEL.MODEL.CAD.vert;
    faces    = MODEL.MODEL.CAD.faces;
    h_cube   = patch('Vertices', vertices, 'Faces', faces, 'FaceColor', '#708090', 'EdgeColor', 'k', 'EdgeAlpha', 0.05, 'LineWidth', 0.5);


    for i = 1:length(Q)

        subplot(fig1);

        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %  STEP #1 : Rotate COMP using quaternion
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % update_vector(Q(i,:), COMP_DIR, COMP_VECTOR, 0.5);
        
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %  STEP #2 : Rotate SUN_VECTOR using quaternion
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        SUN_VECTOR(SUN, SUN_VEC(i,:))


        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %  STEP #3 : Rotate STR using quaternion
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        [~, cone_handle1] = STR_update(Q(i,:), STR1_VEC, STR1_quiver, cone_handle1);
        
        [~, cone_handle2] = STR_update(Q(i,:), STR2_VEC, STR2_quiver, cone_handle2);
        

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
        set(time_text, 'String', datestr(MODEL.TREND.DATE(i)));

        view([1.318e+02,17.36])
        grid on; box on;
        axis([-1 1 -1 1 -1 1]);
        pbaspect([1 1 1.5])
        set(gca, 'ZDir', 'reverse');
        set(gca, 'YDir', 'reverse');
        xlabel('LVLH.X'); ylabel('LVLH.Y'); zlabel('LVLH.Z');
        title(string)

        if MODEL.TREND.ECLI(i) == 1
            colour = 'r';
        else
            colour = 'b';
        end

        subplot(fig2);
        scatter3(MODEL.TREND.ECI(i,1), MODEL.TREND.ECI(i,2), MODEL.TREND.ECI(i,3),'.','k','LineWidth',2);
        plot_globe();
        hold on;

        subplot(fig3);
        groundtrack(MODEL.TREND.LLA(i,:),colour);
        hold on;


        frame = getframe(gcf);
        writeVideo(writerObj, frame);

        drawnow; 
    end

    close(writerObj)
    disp('Trending File Propagation Completed!')
end