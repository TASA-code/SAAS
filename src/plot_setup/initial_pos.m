function [] = initial_pos(flag)

    figure;   

    hold on;
    LVLH(0);
    quiver3(0,0,0, -1, 0, 0, 'color', "#77AC30", 'LineWidth', 2,'Linestyle',':');
    text(-1, 0, 0, '+V direction', 'HorizontalAlignment', 'right','FontWeight','bold');

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %  PRE-STEP #1 : Construct THRUSTER vector
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    OBRCS1();
    OBRCS2();
    RCSDM1();
    RCSDM2();

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %  PRE-STEP #2 : Construct STR vector
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    [STR_LOS, ~] = STR_coverage(flag);

    % Plot cone
    [x_cone, y_cone, z_cone, M] = plot_cone(STR_LOS(1), STR_LOS(2), STR_LOS(3));
    surf(x_cone, y_cone, z_cone, 'Parent', hgtransform('Matrix', M), ...
        'LineStyle', 'none', 'FaceColor', 'r', 'EdgeColor', 'none', 'FaceAlpha', 0.1);


    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %  PRE-STEP #3 : Construct TRITON model
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    

    % Create simplified TRITON model
    [vertices, faces] = FS9_SAR();
    patch('Vertices', vertices, 'Faces', faces, 'FaceColor', '#708090', 'EdgeColor', 'k', 'LineWidth', 1.5);


    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    grid on; box on;
    xlabel('Body.X'); ylabel('Body.Y'); zlabel('Body.Z');
    title('Final Attitude (Bus Frame)')
    axis_limits = [-1 1 -1 1 -1 1 -1 1];
    view([42.77 34.77])

    legend("Body axis","LVLH.x","OBRCS_1", "OBRCS_2", ...
        "RCSDM_1", "RCSDM_2", "STR", 'Location', 'eastoutside');

    if flag == 1
        axis_limits = [-2.25 2.25 -2.25 2.25 -1.5 1.5];
        legend(" Body axis","LVLH.x","OBRCS_1", "OBRCS_2", ...
            "RCSDM_1", "RCSDM_2", "Earth Blockage", "STR", 'Location', 'eastoutside');
    end


    axis(axis_limits)
    set(gca, 'ZDir', 'reverse');
    set(gca, 'YDir', 'reverse');
    % leg.NumColumns = 3;


end
