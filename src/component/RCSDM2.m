function [DIR, VECTOR] = RCSDM2()
    
    THR_location = [0.118926  0.033122  1.19889];
    cg = [ 0.000985  0.0586417  0.494153 ];
    Vector_R = THR_location-cg;
    RCSDM_vector =  Vector_R/norm(Vector_R);

    % RCSDM_vector   = quaternion_rotate(RCSDM_vector, [0 0 0 1]);
    DIR     = quaternion(0, RCSDM_vector(1), RCSDM_vector(2), RCSDM_vector(3));
    VECTOR          = quiver3(0,0,0,RCSDM_vector(1), RCSDM_vector(2), RCSDM_vector(3),'r', 'LineWidth', 3);

end