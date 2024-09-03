function [] = SUN_VECTOR(SUN, sun_vec)

    temp = [sun_vec(1), sun_vec(2), sun_vec(3)];
    update_vector([0 0 0 1], temp, SUN, 1, '');

end
