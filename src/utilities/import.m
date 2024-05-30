function [dates, tlm] = import(filename, format)

    %% NOTE:%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %  File type that is workable for this function are .txt files
    %  Data from Ntrend-SOCC has to be pre-processed by deleting the  
    %      headers before the data
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    % Open the file
    file = fopen(['data/', filename], 'r');
    if file == -1
        error('Cannot open file: %s', filename);
    end
    
    % Read the data using textscan
    data = textscan(file, format);
    fclose(file);

    % Check if the format contains '%s'
    if contains(format, '%s')
        % Handle the case where the date is included
        time = data{1};
        dates = datetime(time, 'InputFormat', 'uuuu-DDD-HH:mm:ss.SSS');
        tlm = cell2mat(data(2:end));
    else
        % Handle the case where there is no date string
        dates = [];
        tlm = cell2mat(data);
    end
end