function [vertices, faces] = model_setup(CG, file_name, rotation)

    % Load the STL file
    model = stlread(file_name);

    % Extract vertices and faces
    vertices = model.Points;
    faces = model.ConnectivityList;

    % Calculate the maximum extent of the model along each axis
    max_extent = max(vertices) - min(vertices);

    % Determine the maximum extent along any axis
    max_extent = max(max_extent);

    % Calculate the scaling factor
    scaling_factor = 1.4 / max_extent;

    % Scale model
    vertices = (vertices - CG) * scaling_factor;

    
    % Convert tilt angle to radians
    rot_angle_rad = deg2rad(rotation);
    
    % Define a transformation matrix for tilting around the z-axis
    rot_matrix = [cos(rot_angle_rad), -sin(rot_angle_rad), 0;
                  sin(rot_angle_rad),  cos(rot_angle_rad), 0;
                  0,                   0,                  1];
    
    % Tilt the vertices around the z-axis
    vertices = (rot_matrix * vertices')';

    % Plot the rotated object
    % figure()
    % hold on
    % patch('Faces', faces, 'Vertices', vertices, 'FaceColor', [0.8 0.8 1.0], 'EdgeColor', 'k');
    % axis equal;
    % grid on;
    % xlabel('X');
    % ylabel('Y');
    % zlabel('Z');
    % set(gca, 'ZDir', 'reverse');
    % set(gca, 'XDir', 'reverse');
    % view([-16.2, 21.0526])

end
