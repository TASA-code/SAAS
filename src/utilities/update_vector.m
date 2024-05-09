function [vec_rotated] = update_vector(q, vector, quiver_vec, ratio)
    
    vec_rotated = quaternion_rotate(vector,q);

    quiver_vec.UData = vec_rotated(1)*ratio;
    quiver_vec.VData = vec_rotated(2)*ratio;
    quiver_vec.WData = vec_rotated(3)*ratio;

end
