function [DIR, VECTOR] = OBRCS1()
    
    THR_location = [-0.0217171  0.0199314  0.00846277];
    cg = [ 0.000985  0.0586417  0.494153 ];
    Vector_R = THR_location-cg;
    OBRCS_vector =  Vector_R/norm(Vector_R);

    DIR     = quaternion(0, OBRCS_vector(1), OBRCS_vector(2), OBRCS_vector(3));
    VECTOR  = quiver3(0,0,0,OBRCS_vector(1), OBRCS_vector(2), OBRCS_vector(3),'b', 'LineWidth', 3);

end