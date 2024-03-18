function [STR_LOS, STR] = STR_coverage(flag)
    
    if flag == 1
        Earth_half_cone_angle = asin(6378/6978)*57.26;
        cone_radius = tand(Earth_half_cone_angle);
        [earth_x, earth_y, earth_z] = cylinder([0, cone_radius]);
        surf(earth_x, earth_y, earth_z, 'LineStyle', 'none', 'FaceAlpha', 0.2);
    end

    % STR vector pointing +z direction and construct by str2body rotation matrix
    % str2body = [ 0.0,         1.0,    0.0
    %              0.81915204,  0.0,   -0.57357
    %             -0.57357644,  0.0,   -0.81815204];
    % STR_vector = str2body * [0 0 1]';

    STR_vector = [0  -0.642787609686539 -0.766044443118978];
    STR_LOS    = quaternion(0, STR_vector(1), STR_vector(2), STR_vector(3));
    STR        = quiver3(0,0,0,STR_vector(1), STR_vector(2), STR_vector(3),'color', '#EDB120', 'LineWidth', 3);

end