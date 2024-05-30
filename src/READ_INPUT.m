function INPUT = READ_INPUT(filename)
    
    % Open the file
    fid = fopen(['input/', filename], 'r');
    if fid == -1
        error('Cannot open file: %s', filename);
    end

    % Read the entire file content
    file_content = fread(fid, '*char')';
    fclose(fid);

    % Initialize INPUT structure
    INPUT = struct();
    INPUT.MODE      = '';
    INPUT.MODEL     = struct('NAME', '', 'CG', [], 'CAD_FILE', '');
    INPUT.ENV       = struct('ENV', '');
    INPUT.COMPONENT = struct('STR1', [], 'STR2', [], 'OBSERV', []);
    INPUT.OPTION    = struct('STR_CONE_VIEW', []);
    INPUT.VALUE     = struct('QUAT', []);

    % Define patterns to match each section
    patterns = struct();
    patterns.mode       = 'MODE\s+(\w+)';
    patterns.model      = 'MODEL\s+(\w+)';
    patterns.cg         = 'CG\s+\[(.*?)\]';
    patterns.cad_file   = 'CAD FILE\s+''(.*?)''';
    patterns.beta       = 'BETA_ANGLE\s+(\w+)';
    patterns.str1       = 'STR1\s+\[(.*?)\]\s+\[(.*?)\]';
    patterns.str2       = 'STR2\s+\[(.*?)\]\s+\[(.*?)\]';
    patterns.observ     = 'OBSERV\s+\[(.*?)\]\s+\[(.*?)\]';
    patterns.STR_VIEW   = 'STR_CONE_VIEW\s+(\w+)';



    % Match and extract each section using regular expressions
    INPUT.MODE           = regexp(file_content, patterns.mode, 'tokens', 'once');
    INPUT.MODEL.NAME     = regexp(file_content, patterns.model, 'tokens', 'once');
    INPUT.MODEL.CG       = regexp(file_content, patterns.cg, 'tokens', 'once');
    INPUT.MODEL.CAD_FILE = regexp(file_content, patterns.cad_file, 'tokens', 'once');
    BETA_ANGLE_matches   = regexp(file_content, patterns.beta, 'tokens', 'once');
    str1_matches         = regexp(file_content, patterns.str1, 'tokens', 'once');
    str2_matches         = regexp(file_content, patterns.str2, 'tokens', 'once');
    observ_matches       = regexp(file_content, patterns.observ, 'tokens', 'once');
    STR_VIEW_matches     = regexp(file_content, patterns.STR_VIEW, 'tokens', 'once');
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    % Convert single-element cells to strings
    if ~isempty(INPUT.MODE)
        INPUT.MODE = INPUT.MODE{1};
    end
    if ~isempty(INPUT.MODEL.NAME)
        INPUT.MODEL.NAME = INPUT.MODEL.NAME{1};
    end


    % Define MODEL input
    if ~isempty(INPUT.OPTION)
        INPUT.OPTION = str2double(STR_VIEW_matches{1});
    end
    if ~isempty(INPUT.MODEL.CG)
        INPUT.MODEL.CG = str2num(INPUT.MODEL.CG{1});
    end
    if ~isempty(INPUT.MODEL.CAD_FILE)
        INPUT.MODEL.CAD_FILE = INPUT.MODEL.CAD_FILE{1};
    end


    % Define ENV input
    if ~isempty(BETA_ANGLE_matches)
        INPUT.BETA_ANGLE = deg2rad(str2double(BETA_ANGLE_matches{1}));
    end


    % Define COMPONENT input
    if ~isempty(str1_matches)
        INPUT.COMPONENT.STR1 = [str2num(str1_matches{1}); str2num(str1_matches{2})];
    end
    if ~isempty(str2_matches)
        INPUT.COMPONENT.STR2 = [str2num(str2_matches{1}); str2num(str2_matches{2})];
    end
    if ~isempty(observ_matches)
        INPUT.COMPONENT.OBSERV = [str2num(observ_matches{1}); str2num(observ_matches{2})];
    end
    

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    [INPUT.CAD.vert, INPUT.CAD.faces] = model_setup(INPUT.MODEL, 0);
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


    switch INPUT.MODE
        case 'simulation'
            patterns.quat_sin   = 'QUAT\s+\[(.*?)\]';
            quat_sin_matches     = regexp(file_content, patterns.quat_sin, 'tokens', 'once');

            if ~isempty(quat_sin_matches)
                INPUT.VALUE.QUAT = str2num(quat_sin_matches{1});
            end

        case 'design'
            patterns.quat_prof  = 'QUAT\s+''(.*?)''';
            quat_prof_matches   = regexp(file_content, patterns.quat_prof, 'tokens', 'once');

            if ~isempty(quat_prof_matches)
                data_file = quat_prof_matches{1};
                [~, INPUT.VALUE.QUAT] = import(data_file, '%f%f%f%f');
            end
        
        case 'propagation'
            INPUT.TREND     = struct('QUAT_TREND', [], 'ECI', [],...
                                     'LLA', [], 'ECLIPSE', [], 'SUN', []);
            
            patterns.QUAT_TREND = 'QUAT_TREND\s+''(.*?)''';
            patterns.ECI        = 'ECI\s+''(.*?)''';
            patterns.LLA        = 'LLA\s+''(.*?)''';
            patterns.ECLIPSE    = 'ECLIPSE\s+''(.*?)''';
            patterns.SUN        = 'SUN\s+''(.*?)''';

            Q_TREND_matches = regexp(file_content, patterns.QUAT_TREND, 'tokens', 'once');
            ECI_matches     = regexp(file_content, patterns.ECI, 'tokens', 'once');
            LLA_matches     = regexp(file_content, patterns.LLA, 'tokens', 'once');
            ECLIPSE_matches = regexp(file_content, patterns.ECLIPSE, 'tokens', 'once');
            SUN_matches     = regexp(file_content, patterns.SUN, 'tokens', 'once');
            
            Q_TREND_file = Q_TREND_matches{1};
            [~, INPUT.TREND.QUAT_TREND] = import(Q_TREND_file, '%s%f%f%f%f');
            INPUT.TREND.QUAT_TREND = INPUT.TREND.QUAT_TREND(2:16:89*16,1:4);
            
            ECI_file = ECI_matches{1};
            [~, INPUT.TREND.ECI] = import(ECI_file, '%s%f%f%f%f');
            
            LLA_file = LLA_matches{1};
            [INPUT.TREND.LLA_DATE, INPUT.TREND.LLA] = import(LLA_file, '%s%f%f');
            
            ECLIPSE_file = ECLIPSE_matches{1};
            [~, INPUT.TREND.ECLIPSE] = import(ECLIPSE_file, '%s%f');
            
            SUN_FILE = SUN_matches{1};
            [~, INPUT.TREND.SUN] = import(SUN_FILE, '%s%f%f%f');

    end

    

end


