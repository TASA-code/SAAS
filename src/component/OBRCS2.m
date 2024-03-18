function [DIR, VECTOR] = OBRCS2()
    
    THR_location = [-0.0237543  -0.0254843   -0.00591477];
    cg = [ 0.000985  0.0586417  0.494153 ];
    Vector_R = THR_location-cg;
    OBRCS_vector =  Vector_R/norm(Vector_R);

    % OBRCS_vector   = quaternion_rotate(OBRCS_vector, [0 0 0 1]);
    DIR      = quaternion(0, OBRCS_vector(1), OBRCS_vector(2), OBRCS_vector(3));
    VECTOR   = quiver3(0,0,0,OBRCS_vector(1), OBRCS_vector(2), OBRCS_vector(3),'b', 'LineWidth', 3);

end