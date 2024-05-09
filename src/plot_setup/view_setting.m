function [] = view_setting(flag,string)

    axis_limits = [-1 1 -1 1 -1 1 -1 1];
    view([60.045,16.76])

    legend("Rotation axis", "LVLH.X", "LVLH.Y", "LVLH.Z",...
            "Body.x", "Body.y", "Body.z", ...
            "STR_1", "STR_2", 'Location', 'eastoutside');

    if flag == 1 
        legend("Rotation axis", "LVLH.X", "LVLH.Y", "LVLH.Z",...
                "Body.x", "Body.y", "Body.z", ...
                "Earth Blockage", "STR", 'Location', 'eastoutside');
    end

    grid on; box on;
    axis(axis_limits);
    pbaspect([1 1 1])
    set(gca, 'ZDir', 'reverse');
    set(gca, 'YDir', 'reverse');
    xlabel('LVLH.X'); ylabel('LVLH.Y'); zlabel('LVLH.Z');
    title(string)

end
