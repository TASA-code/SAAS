function [vertices, faces] = FS9_SAR()

    CoM = [2.7717896e+00  1.8211494e+01  8.9988957e+02]; % (mm)

    % gm = fegeometry('0-fs9_mdi_v1_asm_color.stp');
    % pdegplot(gm)

    % Load the STL file
    FS9 = stlread('fs9.stl');

    % Extract vertices and faces
    vertices = FS9.Points;
    faces = FS9.ConnectivityList;

    % Calculate the maximum extent of the model along each axis
    max_extent = max(vertices) - min(vertices);

    % Determine the maximum extent along any axis
    max_extent = max(max_extent);

    % Calculate the scaling factor
    scaling_factor = 1.7 / max_extent;

    % Scale model
    vertices = (vertices - CoM) * scaling_factor;

    % Plot the rotated object
    % figure()
    % patch('Faces', faces, 'Vertices', vertices, 'FaceColor', [0.8 0.8 1.0], 'EdgeColor', 'k');
    % axis equal;
    % grid on;
    % xlabel('X');
    % ylabel('Y');
    % zlabel('Z');
    % set(gca, 'ZDir', 'reverse');
    % view([-16.2, 21.0526])


end