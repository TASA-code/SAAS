function [x_cone, y_cone, z_cone, M] = plot_cone(xx, yy, zz)

    % Update cone position and size
    FOV = 26;
    cone_height = norm([xx, yy, zz]);
    cone_radius = tand(FOV) * cone_height;
    [x_cone, y_cone, z_cone] = cylinder([0, cone_radius]);
    
    z_cone = z_cone * cone_height;

    % Calculate the direction vector from the cone center to the target point
    % Define the target point
    target_point = [xx, yy, zz];
    
    % Calculate the direction vector from the origin to the target point
    direction_vector = target_point / norm(target_point);
    
    % Calculate the translation vector to position the cone apex at the origin
    translation_vector = -cone_height/128 * direction_vector - cone_height/128 * direction_vector;        

    % Calculate the rotation axis and angle to align the cone with the direction vector
    rotation_axis = cross([0, 0, 1], direction_vector);
    rotation_angle = acos(dot([0, 0, 1], direction_vector));
    
    % Create the rotation matrix
    rotation_matrix = makehgtform('axisrotate', rotation_axis, rotation_angle);
    
    % Create the translation matrix
    translation_matrix = eye(4);
    translation_matrix(1:3, 4) = translation_vector;
    
    % Combine the rotation and translation to form the transformation matrix
    M = translation_matrix * rotation_matrix;

end