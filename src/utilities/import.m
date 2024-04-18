function [dates, tlm] = import(filename, format)

    %% NOTE:%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %  File type that is workable for this function are .txt files
    %  Data from Ntrend-SOCC has to be pre-processed by deleting the  
    %      headers before the data
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    file = fopen(['data/',filename], 'r');
    data = textscan(file, format);
    fclose(file);

    time = data{1};
    dates = datetime(time, 'InputFormat', 'uuuu-DDD-HH:mm:ss.SSS');
    tlm  = cell2mat(data(2:end));

end