function [vertices, faces] = FS9_SAR()

    % % Parameters
    % radius = 0.601; % Radius of the disk (m)
    % thickness = 0.01; % Thickness of the disk (m)

    % % Define the vertices for the first disk
    % centre = [0, 0, 0];
    % circum = [radius*cosd(linspace(0, 360, 20)); radius*sind(linspace(0, 360, 20)); zeros(1, 20)].'; % Using 20 points for the circumference

    % % Define the vertices for the second disk
    % centre_up = [0, 0, thickness]; % Center of the second disk is at z=1
    % circum_up = circum + [0, 0, thickness]; % Shift the points of the circumference up by 1 unit in z-direction

    % % Combine all vertices
    % vertices = [centre; circum; centre_up; circum_up];

    % % Plot the vertices
    % figure();
    % scatter3(vertices(:,1), vertices(:,2), vertices(:,3));

    % % Define faces for the first disk
    % faces1 = [(1:length(circum)+1)', [2:length(circum)+1, 1]', ones(length(circum)+1, 1)];


    % % Define faces for the second disk
    % faces2 = [length(circum) + 2 + (1:length(circum))', length(circum) + 2 + [2:length(circum), 1]', (2 * ones(length(circum), 1) + length(circum))]; % Offset the indices by the number of vertices in the first disk and set the z-value to 2
    
    
    % % Define side faces for the cylinder (rectangles formed by two triangles)
    % num_vertices_per_disk = length(circum);
    % faces_side = zeros(num_vertices_per_disk-1, 3);

    % % Define side faces connecting corresponding vertices from the first and second disks
    % for i = 1:num_vertices_per_disk-1
    %     % Define indices for vertices
    %     vertex1 = i;
    %     vertex2 = i + num_vertices_per_disk;
    %     vertex3 = i + 1;
    %     vertex4 = i + 1 + num_vertices_per_disk;
        
    %     % Define first triangle
    %     faces_side(2*(i-1) + 1, :) = [vertex1, vertex2, vertex4];
        
    %     % Define second triangle
    %     faces_side(2*i, :) = [vertex1, vertex4, vertex3];
    % end


    % % Concatenate all faces
    % faces = [faces1; faces2; faces_side];



% Load the STL file
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
scaling_factor = 1 / max_extent;

% % Define the rotation angles (in degrees)
% theta_x = 45;  % Rotate around x-axis by 45 degrees
% theta_y = 0;   % No rotation around y-axis
% theta_z = 0;   % No rotation around z-axis

% % Convert angles to radians
% theta_x = deg2rad(theta_x);
% theta_y = deg2rad(theta_y);
% theta_z = deg2rad(theta_z);

% % Define rotation matrices
% Rx = [1 0 0; 0 cos(theta_x) -sin(theta_x); 0 sin(theta_x) cos(theta_x)];
% Ry = [cos(theta_y) 0 sin(theta_y); 0 1 0; -sin(theta_y) 0 cos(theta_y)];
% Rz = [cos(theta_z) -sin(theta_z) 0; sin(theta_z) cos(theta_z) 0; 0 0 1];

% % Combine rotation matrices
% R = Rz * Ry * Rx;

% Rotate vertices
% vertices = (R * vertices')';
vertices = vertices*scaling_factor;

% Plot the rotated object
patch('Faces', faces, 'Vertices', vertices, 'FaceColor', [0.8 0.8 1.0], 'EdgeColor', 'k');
axis equal;
grid on;
xlabel('X');
ylabel('Y');
zlabel('Z');


set(gca, 'ZDir', 'reverse');
view([-16.2, 21.0526])


end