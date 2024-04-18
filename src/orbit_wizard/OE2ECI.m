function [r_ECI, v_ECI] = OE2ECI(OE)
    
    mu_E = 3.986004418e14;     % Earth gravitational parameter (m^3/s^2)    

    % define initial orbital elements (ECI)
    a = OE(1)*1000; e = OE(2); i = deg2rad(OE(3)); 
    RAAN = deg2rad(OE(4)); w = deg2rad(OE(5)); theta = deg2rad(OE(6));
    
    h = sqrt(mu_E*a*(1-e^2));
    
    A_w = [cos(w) sin(w) 0; -sin(w) cos(w) 0; 0 0 1];
    A_i = [1 0 0; 0 cos(i) sin(i); 0 -sin(i) cos(i)];
    A_RAAN = [cos(RAAN) sin(RAAN) 0; -sin(RAAN) cos(RAAN) 0; 0 0 1];
    
    A = transpose(A_w*A_i*A_RAAN);
    
    i_e = [1;0;0]; i_p = [0;1;0];
    
    r_p = (h^2/(mu_E*(1+e*cos(theta))))*(cos(theta)*i_e + sin(theta)*i_p);
    v_p = (mu_E/h)*(-sin(theta)*i_e + (e+cos(theta))*i_p);
    
    r_ECI = A*r_p;
    v_ECI = A*v_p;
    
    sent1 = ['The Initial Position is ', '(',num2str(r_ECI(1)/1000),' ',num2str(r_ECI(2)/1000),' ',num2str(r_ECI(3)/1000),')'];
    disp(sent1)
    
    sent2 = ['The Initial Velocity is ', '(',num2str(v_ECI(1)/1000),' ',num2str(v_ECI(2)/1000),' ',num2str(v_ECI(3)/1000),')'];
    disp(sent2)


end
