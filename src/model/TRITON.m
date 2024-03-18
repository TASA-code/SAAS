function [vertices, faces] = TRITON()
    
    % Define cube vertices
    vertices = [0.12 -0.12 -0.12;   % Vertex 1
                0.12  0.12 -0.12;   % Vertex 2
               -0.12  0.12 -0.12;   % Vertex 3
               -0.12 -0.12 -0.12;   % Vertex 4
                0.12 -0.12  0.12;   % Vertex 5
                0.12  0.12  0.12;   % Vertex 6
               -0.12  0.12  0.12;   % Vertex 7
               -0.12 -0.12  0.12;   % Vertex 8
               -0.01   0.2  -0.2;    % Plate 1, Vertex 1
                0.01   0.2  -0.2;    % Plate 1, Vertex 2
                0.01   0.7  -0.2;    % Plate 1, Vertex 3
               -0.01   0.7  -0.2;    % Plate 1, Vertex 4
               -0.01   0.2   0.2;    % Plate 1, Vertex 5
                0.01   0.2   0.2;    % Plate 1, Vertex 6
                0.01   0.7   0.2;    % Plate 1, Vertex 7
               -0.01   0.7   0.2;    % Plate 1, Vertex 8
               -0.01   0.8  -0.2;    % Plate 2, Vertex 1
                0.01   0.8  -0.2;    % Plate 2, Vertex 2
                0.01   1.3  -0.2;    % Plate 2, Vertex 3
               -0.01   1.3  -0.2;    % Plate 2, Vertex 4
               -0.01   0.8   0.2;    % Plate 2, Vertex 5
                0.01   0.8   0.2;    % Plate 2, Vertex 6
                0.01   1.3   0.2;    % Plate 2, Vertex 7
               -0.01   1.3   0.2];   % Plate 2, Vertex 8

    
    % Define cube faces
    faces = [1 2 6 5;        % Face 1 (bottom)
             2 3 7 6;        % Face 2 (right)
             3 4 8 7;        % Face 3 (top)
             4 1 5 8;        % Face 4 (left)
             1 2 3 4;        % Face 5 (front)
             5 6 7 8;        % Face 6 (back)
             9 10 11 12;     % Face 7 (plate 1 front)
             10 11 15 14;    % Face 8 (plate 1 right)
             11 12 16 15;    % Face 9 (plate 1 back)
             12 9  13 16;    % Face 10 (plate 1 left)
             9 10 14 13;     % Face 11 (plate 1 bottom)
             13 14 15 16;    % Face 12 (plate 1 top)
             17 18 19 20;    % Face 13 (plate 2 front)
             18 19 23 22;    % Face 14 (plate 2 right)
             19 20 24 23;    % Face 15 (plate 2 back)
             20 17 21 24;    % Face 16 (plate 2 left)
             17 18 22 21;    % Face 17 (plate 2 bottom)
             21 22 23 24];   % Face 18 (plate 2 top)

    trim_angle = -30; % Define the tilt angle in degrees
    
    % Convert tilt angle to radians
    tilt_angle_rad = deg2rad(trim_angle);
    
    % Define a transformation matrix for tilting around the z-axis
    tilt_matrix = [cos(tilt_angle_rad), -sin(tilt_angle_rad), 0;
                   sin(tilt_angle_rad), cos(tilt_angle_rad), 0;
                   0, 0, 1];
    
    % Apply the transformation to the plate vertices
    plate1_vertices = vertices(9:16, :);
    plate2_vertices = vertices(17:24, :);
    
    % Tilt the vertices around the z-axis
    plate1_vertices_tilted = (tilt_matrix * plate1_vertices')';
    plate2_vertices_tilted = (tilt_matrix * plate2_vertices')';
    
    % Update the tilted vertices in the main vertices matrix
    vertices(9:16, :) = plate1_vertices_tilted;
    vertices(17:24, :) = plate2_vertices_tilted;

    
end