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
%   This code is provided under the MIT License.
%
%   Written by Cooper Chang Chien <cooper@tasa.org.tw>, January 2024.
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


function [] = ATT_design(sim, model)

    
    Q      = model.q_design_ECI
    energy = model.design_energy_ratio;
    Q_LVLH = model.q_design_LVLH;

    % [ECI_R, ~] = ATT_orbit_wiz(sim, model);
    % INTERVAL = length(ECI_R)/length(Q);
    % ECI_R = ECI_R(1:INTERVAL:end,:);

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
    % LVLH();
    [BODY_VEC, BODY_quiver] = BODY_AXIS();

    % SUN Beta angle
    quiver3(0,0,0,cos(sim.orbit.beta_angle),sin(sim.orbit.beta_angle),0,"LineWidth",3,'color',"#EDB120")


    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %  PRE-STEP #1 : Construct THRUSTER vector
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    % [COMP_DIR, COMP_VECTOR] = create_comp(model);
    SA_START = [1,-0.3,0];
    SA_END = [0,-1,0];

    SA_VEC = quiver3(SA_START(1), SA_START(2), SA_START(3), SA_END(1), SA_END(2), SA_END(3),"LineWidth",2,'color',"b", 'LineStyle','-.');
    

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %  PRE-STEP #2 : Construct STR vector
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    [STR_VEC, STR_quiver] = STR(sim.flag.view, model.component.STR1);
    cone_handle = [];

    [STR2_VEC, STR2_quiver] = STR(sim.flag.view, model.component.STR2);
    cone_handle2 = [];

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %  PRE-STEP #3 : Create model
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    vertices = model.CAD.vert;
    faces = model.CAD.faces;
    model = patch('Vertices', vertices, 'Faces', faces, 'FaceColor', '#708090', 'EdgeColor', 'k', 'EdgeAlpha', 0.15, 'LineWidth', 0.5);

    subplot(fig2)
    hold on;
    LVLH();
    quiver3(0,0,0,cos(sim.orbit.beta_angle),sin(sim.orbit.beta_angle),0,"LineWidth",3,'color',"#EDB120")
    model2 = patch('Vertices', vertices, 'Faces', faces, 'FaceColor', '#708090', 'EdgeColor', 'k', 'EdgeAlpha', 0.15, 'LineWidth', 0.5);

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    for i = 1:length(Q)

        subplot(fig1);
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %  STEP #1 : Rotate COMP using quaternion
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % update_vector(Q(i,:), COMP_DIR, COMP_VECTOR, 0.5);
        % rot_start = quaternion_rotate([0.198, -0.388, -0.01],Q(i,:));
        % rot_end   = quaternion_rotate([-0.388, -0.198,-0.01], Q(i,:));
        % set(rot_vec, 'XData', rot_start(1), 'YData', rot_start(2), 'ZData', rot_start(3),...
        %          'UData', rot_end(1), 'VData', rot_end(2), 'WData', rot_end(3));
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %  STEP #2 : Rotate SUN_VECTOR using quaternion
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % SUN_VECTOR(SUN, SUN_VEC(i,:))
        

        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %  STEP #3 : Rotate STR using quaternion
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        [~, cone_handle]  = STR_update(Q(i,:), STR_VEC, STR_quiver, cone_handle);
        
        [~, cone_handle2] = STR_update(Q(i,:), STR2_VEC, STR2_quiver, cone_handle2);

        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %  STEP #4 : Rotate TRITON model using quaternion
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        q_temp = quaternion(Q(i,1), Q(i,2), Q(i,3), Q(i,4));
        R = rotmat(q_temp,'point'); 

        center = [0, 0, 0];  % Center of the cube
        cube_vertices = ((R * (vertices' - center') + center'))';
        set(model, 'Vertices', cube_vertices, 'Faces', faces);


        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %  STEP #5 : Rotate Body axis 
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        for k = 1:3   
            update_vector(Q(i,:), BODY_VEC(k,:), BODY_quiver(k), 0.5, ' ');
            if k == 3
                update_vector(Q(i,:), BODY_VEC(k,:), BODY_quiver(k), 0.5, 'z');
            end
        end

        origin_vec = quaternion_rotate(SA_START, Q(i,:));
        final_vec  = quaternion_rotate(SA_END, Q(i,:));
        
        SA_VEC.XData = origin_vec(1)*0.3;
        SA_VEC.YData = origin_vec(2)*0.3;
        SA_VEC.ZData = origin_vec(3)*0.3;
        SA_VEC.UData = final_vec(1)*0.3;
        SA_VEC.VData = final_vec(2)*0.3;
        SA_VEC.WData = final_vec(3)*0.3;


        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        view([60.045,16.76])
        grid on; box on;
        axis([-1 1 -1 1 -1 1]);
        pbaspect([1 1 1])
        set(gca, 'ZDir', 'reverse');
        set(gca, 'YDir', 'reverse');
        xlabel('X'); ylabel('Y'); zlabel('Z');
        title('Body to ECI rotation')
        
        % legend('BODY.X', 'BODY.Y', 'BODY.Z', 'SUN', 'Solar Array',... 
        %         'STR', 'STR', 'FS9','Earth pos','Location','westoutside')
        


        subplot(fig2);
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %  STEP #4 : Rotate TRITON model using quaternion
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
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