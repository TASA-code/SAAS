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

    
    Q = model.q_design_data

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %  PRE-STEP #0 : Setup frame recording
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    filename = 'output/ATT_design.mp4';
    writerObj = VideoWriter(filename, 'MPEG-4');
    open(writerObj);


    figure;

    hold on;
    LVLH();
    % [bq, bvec] = BODY_AXIS();

    data_text = text('Position', [-0.476,-0.092,-1.03]);

    % SUN Beta angle
    quiver3(0,0,0,cos(sim.orbit.beta_angle),sin(sim.orbit.beta_angle),0,"LineWidth",3,'color',"#EDB120")


    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %  PRE-STEP #1 : Construct THRUSTER vector
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    % [COMP_DIR, COMP_VECTOR] = create_comp(model);


    % SUN_VEC = model.sun_data;
    % SUN = quiver3(0,0,0,SUN_VEC(1),SUN_VEC(2),SUN_VEC(3),'color','#EDB120', 'LineWidth', 2);


    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %  PRE-STEP #2 : Construct STR vector
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    [STR_VEC, STR_quiver] = STR(sim.flag.view, model.component.STR1);
    cone_handle = [];

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %  PRE-STEP #3 : Create model
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    vertices = model.CAD.vert;
    faces = model.CAD.faces;
    model = patch('Vertices', vertices, 'Faces', faces, 'FaceColor', '#708090', 'EdgeColor', 'k', 'EdgeAlpha', 0.15, 'LineWidth', 0.5);

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


    for i = 1:length(Q)

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
        [~, cone_handle] = STR_update(Q(i,:), STR_VEC, STR_quiver, cone_handle);



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
        % for k = 1:3   
        %     update_vector(euler_to_quaternion([0,p(i),0]), LVLH_q(k,:), LVLH_vec(k), 1);
        % end

        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        set(data_text, 'String', num2str(Q(i,:)));

        view([60.045,16.76])
        grid on; box on;
        axis([-1 1 -1 1 -1 1]);
        pbaspect([1 1 1])
        set(gca, 'ZDir', 'reverse');
        set(gca, 'YDir', 'reverse');
        xlabel('X'); ylabel('Y'); zlabel('Z');
        title(string)
        
        legend('LVLH', 'LVLH', 'LVLH', 'Sun', 'FS9','Location','eastoutside')


        frame = getframe(gcf);
        writeVideo(writerObj, frame);

        drawnow; 
    end

    close(writerObj)
    disp('Propagation Completed!')
end