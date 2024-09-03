function [] = initial_pos(sim, model)

    figure;   

    hold on;
    LVLH();

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %  PRE-STEP #1 : Construct THRUSTER vector
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %  PRE-STEP #2 : Construct STR vector
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    [STR_LOS1, ~] = STR(sim.flag.view, model.component.STR1);

    [STR_LOS2, ~] = STR(sim.flag.view, model.component.STR2);


    % Plot cone
    [x_cone1, y_cone1, z_cone1, M1] = plot_cone(STR_LOS1(1), STR_LOS1(2), STR_LOS1(3));
    surf(x_cone1, y_cone1, z_cone1, 'Parent', hgtransform('Matrix', M1), ...
        'LineStyle', 'none', 'FaceColor', 'r', 'EdgeColor', 'none', 'FaceAlpha', 0.1);
        
    [x_cone2, y_cone2, z_cone2, M2] = plot_cone(STR_LOS2(1), STR_LOS2(2), STR_LOS2(3));
    surf(x_cone2, y_cone2, z_cone2, 'Parent', hgtransform('Matrix', M2), ...
        'LineStyle', 'none', 'FaceColor', 'r', 'EdgeColor', 'none', 'FaceAlpha', 0.1);
    

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %  PRE-STEP #3 : Construct TRITON model
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    

    % Create simplified TRITON model
    vertices = model.CAD.vert;
    faces = model.CAD.faces;
    patch('Vertices', vertices, 'Faces', faces, 'FaceColor', '#708090', 'EdgeColor', 'k', 'EdgeAlpha', 0.15, 'LineWidth', 0.5);


    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    view([60.045,16.76])
    grid on; box on;
    axis([-0.8 0.8 -0.8 0.8 -0.8 0.8]);
    pbaspect([1 1 1])
    set(gca, 'ZDir', 'reverse');
    set(gca, 'YDir', 'reverse');
    xlabel('LVLH.X'); ylabel('LVLH.Y'); zlabel('LVLH.Z');
    title('Initial Attitude (Bus Frame)')


end
