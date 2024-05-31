%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%   SAAS ATT_design.m
%
%   Cooper Chang Chien
%
%   Input:
%     @param sim      :  (struct)  Simulation setups
%     @param model    :  (struct)  Model parameters
%
%
%   Output:
%     Animation of Satellite attitude design 
%
%
%   Copyright (C) System Engineering (SE), TASA - All Rights Reserved
%
%   This code is provided under the Apache License.
%
%   Written by Cooper Chang Chien <cooper@tasa.org.tw>, January 2024.
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


function [] = ATT_design(MODEL)


    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %  PRE-STEP #0 : Setup frame recording
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    filename = 'output/ATT_design.mp4';
    writerObj = VideoWriter(filename, 'MPEG-4');
    open(writerObj);


    figure;
    fig1 = subplot(3,4,[1,2,5,6]);
    fig2 = subplot(3,4,[3,4,7,8]);
    fig3 = subplot(3,4,9:12);
 

    subplot(fig1);

    hold on;
    [BODY_VEC, BODY_quiver] = BODY_AXIS();

    % SUN Beta angle
    BETA_ANGLE = -MODEL.BETA_ANGLE;
    quiver3(0,0,0,cos(BETA_ANGLE),sin(BETA_ANGLE),0,"LineWidth",3,'color',"#EDB120")

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %  PRE-STEP #1 : Construct OBSERV vector
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    [COMP_VEC, COMP_QUIVER] = create_comp(MODEL);


    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %  PRE-STEP #2 : Construct STR vector
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    [STR_VEC, STR_quiver] = STR(MODEL.OPTION, MODEL.COMPONENT.STR1);
    cone_handle = [];

    [STR2_VEC, STR2_quiver] = STR(MODEL.OPTION, MODEL.COMPONENT.STR2);
    cone_handle2 = [];

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %  PRE-STEP #3 : Create model
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    vertices = MODEL.MODEL.CAD.vert;
    faces = MODEL.MODEL.CAD.faces;
    model = patch('Vertices', vertices, 'Faces', faces, 'FaceColor', '#708090', 'EdgeColor', 'k', 'EdgeAlpha', 0.15, 'LineWidth', 0.5);

    subplot(fig2)
    hold on;
    LVLH();
    quiver3(0,0,0,cos(BETA_ANGLE),sin(BETA_ANGLE),0,"LineWidth",3,'color',"#EDB120")
    model2 = patch('Vertices', vertices, 'Faces', faces, 'FaceColor', '#708090', 'EdgeColor', 'k', 'EdgeAlpha', 0.15, 'LineWidth', 0.5);

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    [Q, Q_LVLH, energy] = q_design_eval([0, -240], BETA_ANGLE, 50);
    [MODEL.RESULT.Q, MODEL.RESULT.Q_LVLH, MODEL.RESULT.ENERGY] = deal(Q, Q_LVLH, energy);
    

    for i = 1:length(Q)

        subplot(fig1);

        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %  STEP #1 : Rotate COMP using quaternion
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        update_vector(Q(i,:), COMP_VEC, COMP_QUIVER, 0.5, '');

        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %  STEP #2 : Rotate STR using quaternion
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        [~, cone_handle]  = STR_update(Q(i,:), STR_VEC, STR_quiver, cone_handle);
        
        [~, cone_handle2] = STR_update(Q(i,:), STR2_VEC, STR2_quiver, cone_handle2);

        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %  STEP #3 : Rotate TRITON model using quaternion
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        q_temp = quaternion(Q(i,1), Q(i,2), Q(i,3), Q(i,4));
        R = rotmat(q_temp,'point'); 

        center = [0, 0, 0];  % Center of the cube
        cube_vertices = ((R * (vertices' - center') + center'))';
        set(model, 'Vertices', cube_vertices, 'Faces', faces);


        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %  STEP #4 : Rotate Body axis 
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        for k = 1:3   
            update_vector(Q(i,:), BODY_VEC(k,:), BODY_quiver(k), 0.5, ' ');
            if k == 3
                update_vector(Q(i,:), BODY_VEC(k,:), BODY_quiver(k), 0.5, 'z');
            end
        end


        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        view([60.045,16.76])
        grid on; box on;
        axis([-1 1 -1 1 -1 1]);
        pbaspect([1 1 1])
        set(gca, 'ZDir', 'reverse');
        set(gca, 'YDir', 'reverse');
        xlabel('X'); ylabel('Y'); zlabel('Z');
        title('Body to ECI rotation')

        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

        subplot(fig2);
        
        q_temp = quaternion(Q_LVLH(i,1), Q_LVLH(i,2), Q_LVLH(i,3), Q_LVLH(i,4));
        R = rotmat(q_temp,'point'); 
        center = [0, 0, 0];  % Center of the cube
        cube_vertices = ((R * (vertices' - center') + center'))';
        set(model2, 'Vertices', cube_vertices, 'Faces', faces);
        
        view([60.045,16.76])
        grid on; box on;
        axis([-1 1 -1 1 -1 1]);
        pbaspect([1 1 1])
        set(gca, 'ZDir', 'reverse');
        set(gca, 'YDir', 'reverse');
        xlabel('X'); ylabel('Y'); zlabel('Z');
        title('Body to LVLH rotation')


        subplot(fig3)
        scatter(i, energy(i), '.', 'MarkerEdgeColor','r','MarkerFaceColor','r','LineWidth',2)
        hold on;
        scatter(i, 1, '.', 'MarkerEdgeColor','k','MarkerFaceColor','k','LineWidth',2)
        axis([0 length(Q) 0 1.2]);
        grid on; box on;
        ylabel('Energy ratio')
        title('SA Solar Energy Ratio')
        legend('Mission Orbit','Dawn-Dusk Orbit','location','southeast')
        set(gca,"XTickLabel",'')

        
        frame = getframe(gcf);
        writeVideo(writerObj, frame);

        drawnow; 

    end

    close(writerObj)
    disp('Propagation Completed!')

end