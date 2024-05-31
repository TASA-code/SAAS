function [QUAT, QUIVER] = create_comp(MODEL)
    
    COMP_location = MODEL.COMPONENT.USER(2,:);
    R = COMP_location - MODEL.COMPONENT.USER(1,:);

    DIR     =  R/norm(R);
    QUAT    = [DIR(1), DIR(2), DIR(3)];
    QUIVER  = quiver3(0,0,0,DIR(1), DIR(2), DIR(3),'b', 'LineWidth', 3);

end