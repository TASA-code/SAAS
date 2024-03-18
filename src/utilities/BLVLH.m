function [quat, vec] = BLVLH()
    
    vec(1) = quiver3(0,0,0, 1, 0, 0, 'color', "#43A5BE", 'LineWidth', 3);
    vec(2) = quiver3(0,0,0, 0, 1, 0, 'color', "#43A5BE", 'LineWidth', 3);
    vec(3) = quiver3(0,0,0, 0, 0, 1, 'color', "#43A5BE", 'LineWidth', 3);
    quat(1) = quaternion(0,1,0,0);
    quat(2) = quaternion(0,0,1,0);
    quat(3) = quaternion(0,0,0,1);

end