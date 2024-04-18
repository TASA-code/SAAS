function [OE] = getinput()

    a_input = input('Enter SMA (km): ', 's');
    a = str2double(strsplit(a_input));
    
    e_input = input('Enter eccentricity (-): ', 's');
    e = str2double(strsplit(e_input));

    i_input = input('Enter inclination (deg): ', 's');
    i = str2double(strsplit(i_input));

    RAAN_input = input('Enter RAAN (deg): ', 's');
    RAAN = str2double(strsplit(RAAN_input));

    w_input = input('Enter argument of perigee (deg): ', 's');
    w = str2double(strsplit(w_input));

    theta_input = input('Enter true anomaly (deg): ', 's');
    theta = str2double(strsplit(theta_input));

    OE = [a, e, i, RAAN, w, theta];

end