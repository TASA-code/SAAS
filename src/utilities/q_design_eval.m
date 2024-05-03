function q_design = q_design_eval(pitch_span, beta)

    % psi = deg2rad(pitch_span)
    % pitch_span = [pitch_start, pitch_end]
    pitch = linspace(pitch_span(1), pitch_span(2), 20);
    beta  = beta*ones(1,length(pitch));
    % yaw = atan(-cos(pitch)./tan(beta))

    q_design = zeros(length(pitch), 4);

    for i = 1:length(pitch)
        yaw = atan(-cosd(pitch(i))/tan(beta(i)));
        q_design(i,:) = euler_to_quaternion([0 pitch(i) yaw]);
    end



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

