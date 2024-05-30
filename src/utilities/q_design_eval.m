function [q_design_ECI, q_design_LVLH, energy] = q_design_eval(location, beta, interval)

    location = deg2rad(location);
    psi = linspace(location(1), location(2), interval);

    q_design_ECI  = zeros(length(psi), 4);
    q_design_LVLH = zeros(length(psi), 4);
    energy = zeros(length(psi), 1);

    for i = 1:length(psi)

        yaw = atan(-cos(psi(i))/tan(beta));
        energy(i) = cos(beta)*cos(psi(i))*sin(yaw) - sin(beta) * cos(yaw);
        
        % Quaternion for LVLH frame
        q_design_LVLH(i,:) = euler_to_quaternion([0 0 rad2deg(yaw)]);
        
        % Quaternion for ECI frame
        design1 = euler_to_quaternion([0 rad2deg(psi(i)) 0]);
        design2 = euler_to_quaternion([0 0 rad2deg(yaw)]);
        q1 = quaternion(design1(1), design1(2), design1(3), design1(4));
        q2 = quaternion(design2(1), design2(2), design2(3), design2(4));
        q_result = q1 * q2;
        [q_design_ECI(i,1), q_design_ECI(i,2), q_design_ECI(i,3), q_design_ECI(i,4)] = parts(q_result);
    end

    dawn_energy = interval*360/abs(rad2deg(location(2))-rad2deg(location(1)));
    energy_ratio = (sum(energy)/dawn_energy)*100;
    
    for i = 1:length(q_design_LVLH)-1
        dtheta(i) = q_design_LVLH(i+1,1) - q_design_LVLH(i,1);
    end
    
    rad2deg(dtheta);

    fprintf('Orbit SA energy percentage:\t%.2f%%\n\n', energy_ratio);




    % % test = [linspace(0,-25,num); linspace(0,-30,num); linspace(60,65,num)]'
    % num = 30;
    % test = [linspace(0,0,num); linspace(0,-90,num); linspace(60,0,num)]';
    % temp = zeros(length(test),4);
    
    % % euler_to_quaternion([yaw pitch roll])
    % for i = 1:length(temp)
    %     temp(i,:) = euler_to_quaternion(test(i,:));
    % end

    % % test1 = [linspace(0,0,num); linspace(0,-90,num); linspace(60,0,num)]';
    % % temp1 = zeros(length(test1),4);
    
    % % % euler_to_quaternion([yaw pitch roll])
    % % for i = 1:length(temp1)
    % %     temp1(i,:) = euler_to_quaternion(test1(i,:));
    % % end


    % q_design = [temp]



end

