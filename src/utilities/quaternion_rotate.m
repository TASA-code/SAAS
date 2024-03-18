function Vector_final = quaternion_rotate(vector, q)
    
    v     = quaternion(0, vector(1), vector(2), vector(3));
    q_rot = quaternion(q(1), q(2), q(3), q(4));

    rotated_vector1 = q_rot * v * conj(q_rot);
    [~, X, Y, Z] = parts(rotated_vector1);

    Vector_final = [X, Y, Z];

end