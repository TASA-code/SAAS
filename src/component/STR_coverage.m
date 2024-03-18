function [STR_LOS, STR] = STR_coverage(flag)
    
    if flag == 1
        Earth_half_cone_angle = asin(6378/6978)*57.26;
        cone_radius = tand(Earth_half_cone_angle);
        [earth_x, earth_y, earth_z] = cylinder([0, cone_radius]);
        surf(earth_x, earth_y, earth_z, 'LineStyle', 'none', 'FaceAlpha', 0.2);
    end

    STR_LOS = [0  -0.642787609686539 -0.766044443118978];
    % STR_LOS    = quaternion(0, STR_vector(1), STR_vector(2), STR_vector(3));
    STR        = quiver3(0,0,0,STR_LOS(1), STR_LOS(2), STR_LOS(3),'color', '#7E2F8E', 'LineWidth', 3);

end