function [STR_LOS, STR_quiver] = STR(flag, component)
    
    if flag == 1
        Earth_half_cone_angle = asin(6378/6978)*57.26;
        cone_radius = tand(Earth_half_cone_angle);
        [earth_x, earth_y, earth_z] = cylinder([0, cone_radius]);
        surf(earth_x, earth_y, earth_z, 'LineStyle', 'none', 'FaceAlpha', 0.2);
    end

    STR     = component{1,2} - component{1,3};

    % STR_LOS = [0  -0.642787609686539 -0.766044443118978];
    % STR_LOS    = quaternion(0, STR1(1), STR1(2), STR1(3));
    STR_LOS      = STR/norm(STR);
    STR_quiver   = quiver3(0,0,0,STR_LOS(1), STR_LOS(2), STR_LOS(3),'color', '#7E2F8E', 'LineWidth', 3);
end
