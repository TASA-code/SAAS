function [] = view_setting(flag,string)

    axis_limits = [-1 1 -1 1 -1 1 -1 1];
    view([-2.270598883117190e+02,12.343293986035402])

    legend("LVLH","Rotation axis", "Body.x", "Body.y", "Body.z", ...
             "COMP", "STR", 'Location', 'eastoutside');

    if flag == 1 
        axis_limits = [-1.5 1.5 -1.5 1.5 -1.5 1.5];
        view([-137.67 15.61])
        legend("LVLH","Rotation axis", "Body.x", "Body.y", "Body.z", ...
                 "COMP", "Earth Blockage", "STR", 'Location', 'eastoutside');
    end

    grid on; box on;
    axis(axis_limits);
    pbaspect([1 1 1])
    set(gca, 'ZDir', 'reverse');
    set(gca, 'YDir', 'reverse');
    xlabel('LVLH.X'); ylabel('LVLH.Y'); zlabel('LVLH.Z');
    title(string)

end
