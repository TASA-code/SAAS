function [r_ecef, v_ecef] = ECI2ECEF(lla_date, t, r, v)

    epoch = datetime(lla_date(1), 'InputFormat', 'uuuu-DDD-HH:mm:ss.SSS', 'TimeZone', 'UTC');
    r_ecef = zeros(length(t),3);

    for i = 1:length(t)
        duration_to_add = seconds(t(i));
        new_datetime = epoch + duration_to_add;
            
        % Convert datetime to UTC
        new_utc = datetime(new_datetime, 'TimeZone', 'UTC', 'Format', 'yyyy-MM-dd HH:mm:ss.SSS');
        [r_ecef(i,:), v_ecef(i,:)] = eci2ecef(new_utc,r(i,:),v(i,:));
        
    end

end