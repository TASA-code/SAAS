function [quat, vec] = BODY_AXIS()
    
    quat = eye(3,3);

    vec(1) = quiver3(0,0,0, 1, 0, 0, 'color', "#43A5BE", 'LineWidth', 3);
    vec(2) = quiver3(0,0,0, 0, 1, 0, 'color', "#43A5BE", 'LineWidth', 3);
    vec(3) = quiver3(0,0,0, 0, 0, 1, 'color', "#43A5BE", 'LineWidth', 3);

end