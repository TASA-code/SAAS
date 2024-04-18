function [DIR, VECTOR] = create_comp(model)
    
    cg = model.CG;
    THR_location = model.component.location;
    Vector_R = THR_location-cg;
    DIR =  Vector_R/norm(Vector_R);

    % DIR     = quaternion(0, OBRCS_vector(1), OBRCS_vector(2), OBRCS_vector(3));
    VECTOR  = quiver3(0,0,0,DIR(1), DIR(2), DIR(3),'b', 'LineWidth', 3);

end