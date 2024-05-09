function rot_quaternion = euler_to_quaternion(rot_euler)

    roll  = deg2rad(rot_euler(1));
    pitch = deg2rad(rot_euler(2));
    yaw   = deg2rad(rot_euler(3));


    qs = cos(roll/2) * cos(pitch/2) * cos(yaw/2) - sin(roll/2) * sin(pitch/2) * sin(yaw/2);
    qx = sin(roll/2) * cos(pitch/2) * cos(yaw/2) - cos(roll/2) * sin(pitch/2) * sin(yaw/2);
    qy = cos(roll/2) * sin(pitch/2) * cos(yaw/2) - sin(roll/2) * cos(pitch/2) * sin(yaw/2);
    qz = cos(roll/2) * cos(pitch/2) * sin(yaw/2) - sin(roll/2) * sin(pitch/2) * cos(yaw/2);

    rot_quaternion = [qs, qx, qy, qz];

end
