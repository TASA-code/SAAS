function [START_DIR_q, END_DIR_q, VECTOR] = create_comp(start, model)
    
    % cg = model.CG;
    COMP_location = model.component.location;
    Vector_R = COMP_location-start;
    DIR =  Vector_R/norm(Vector_R);

    START_DIR_q  = quaternion(0, start(1), start(2), start(3));
    END_DIR_q    = quaternion(0, COMP_location(1), COMP_location(2), COMP_location(3));
    VECTOR  = quiver3(start(1),start(2),start(3),DIR(1), DIR(2), DIR(3),'b', 'LineWidth', 3);

end