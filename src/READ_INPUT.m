function INPUT = READ_INPUT(filename)
    
    % Open the file
    fid = fopen(['../input/', filename], 'r');
    if fid == -1
        error('Cannot open file: %s', filename);
    end

    % Read the entire file content
    file_content = fread(fid, '*char')';
    fclose(fid);

    % Initialize INPUT structure
    INPUT = struct();
    INPUT.MODE      = '';
    INPUT.MODEL     = struct('NAME', '', 'CG', [], 'OFF', [], 'FILE', '');
    INPUT.ENV       = struct('BETA_ANGLE', '');
    INPUT.COMPONENT = struct('STR1', [], 'STR2', [], 'USER', []);
    INPUT.OPTION    = struct('STR_VIEW', '');

    % Define patterns to match each section
    patterns = struct();
    patterns.mode       = 'MODE\s+(\w+)';
    patterns.name       = 'NAME\s+(\w+)';
    patterns.cg         = 'CG\s+\[(.*?)\]';
    patterns.off        = 'OFF\s+\[(.*?)\]';
    patterns.cad_file   = 'FILE\s+''(.*?)''';
    patterns.beta       = 'BETA_ANGLE\s+(\w+)';
    patterns.str1       = 'STR1\s+\[(.*?)\]\s+\[(.*?)\]';
    patterns.str2       = 'STR2\s+\[(.*?)\]\s+\[(.*?)\]';
    patterns.user       = 'USER\s+\[(.*?)\]\s+\[(.*?)\]';
    patterns.STR_VIEW   = 'STR_VIEW\s+(\w+)';



    % Match and extract each section using regular expressions
    INPUT.MODE           = regexp(file_content, patterns.mode, 'tokens', 'once');
    INPUT.MODEL.NAME     = regexp(file_content, patterns.name, 'tokens', 'once');
    INPUT.MODEL.CG       = regexp(file_content, patterns.cg, 'tokens', 'once');
    INPUT.MODEL.OFF      = regexp(file_content, patterns.off, 'tokens', 'once');
    INPUT.MODEL.FILE     = regexp(file_content, patterns.cad_file, 'tokens', 'once');
    BETA_ANGLE_matches   = regexp(file_content, patterns.beta, 'tokens', 'once');
    str1_matches         = regexp(file_content, patterns.str1, 'tokens', 'once');
    str2_matches         = regexp(file_content, patterns.str2, 'tokens', 'once');
    user_matches         = regexp(file_content, patterns.user, 'tokens', 'once');
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
    if ~isempty(INPUT.MODEL.CG)
        INPUT.MODEL.CG = str2num(INPUT.MODEL.CG{1});
    end
    if ~isempty(INPUT.MODEL.OFF)
        INPUT.MODEL.OFF = str2num(INPUT.MODEL.OFF{1});
    end
    if ~isempty(INPUT.MODEL.FILE)
        INPUT.MODEL.FILE = INPUT.MODEL.FILE{1};
    end

    % Define ENV input
    if ~isempty(BETA_ANGLE_matches)
        INPUT.ENV.BETA_ANGLE = deg2rad(str2double(BETA_ANGLE_matches{1}));
    end
    if ~isempty(STR_VIEW_matches)
        INPUT.OPTION.STR_VIEW = str2double(STR_VIEW_matches{1});
    end


    % Define COMPONENT input
    if ~isempty(str1_matches)
        INPUT.COMPONENT.STR1 = [str2num(str1_matches{1}); str2num(str1_matches{2})];
    end
    if ~isempty(str2_matches)
        INPUT.COMPONENT.STR2 = [str2num(str2_matches{1}); str2num(str2_matches{2})];
    end
    if ~isempty(user_matches)
        INPUT.COMPONENT.USER = [str2num(user_matches{1}); str2num(user_matches{2})];
    end
    

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    [INPUT.MODEL.CAD.vert, INPUT.MODEL.CAD.faces] = model_setup(INPUT.MODEL, 0, INPUT.MODEL.OFF);
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


    if strcmp(INPUT.MODE, 'simulation')
            INPUT.VALUE     = struct('DESIGN_opt', '', 'FRAME', '', 'QUAT_DESIGN', [], 'QUAT_SINGLE', [], 'QUAT_PROF', []);

            patterns.design_opt = 'DESIGN\s+(\w+)';
            design_opt_matches  = regexp(file_content, patterns.design_opt, 'tokens', 'once');
            
            if ~isempty(design_opt_matches)
                INPUT.VALUE.DESIGN_opt = str2double(design_opt_matches{1});
            end

            if INPUT.VALUE.DESIGN_opt == 0
                patterns.quat_sin   = 'QUAT_SINGLE\s+\[(.*?)\]';
                patterns.quat_prof  = 'QUAT_PROF\s+''(.*?)''';
                
                quat_sin_matches    = regexp(file_content, patterns.quat_sin, 'tokens', 'once');
                quat_prof_matches   = regexp(file_content, patterns.quat_prof, 'tokens', 'once');
    
                if ~isempty(quat_sin_matches)
                    INPUT.VALUE.QUAT_SINGLE = str2num(quat_sin_matches{1});
                end

                if ~isempty(quat_prof_matches)
                    data_file = quat_prof_matches{1};
                    [~, INPUT.VALUE.QUAT_PROF] = import(data_file, '%f%f%f%f');
                end

            elseif INPUT.VALUE.DESIGN_opt == 1
                patterns.frame      = 'FRAME\s+''(\w+)''';
                patterns.quat_des   = 'QUAT_DESIGN\s+\[(.*?)\]';
                
                frame_matches       = regexp(file_content, patterns.frame, 'tokens', 'once');
                quat_des_matches    = regexp(file_content, patterns.quat_des, 'tokens', 'once');

                if ~isempty(quat_des_matches)
                    INPUT.VALUE.QUAT_DESIGN = str2num(quat_des_matches{1});
                end
                if ~isempty(frame_matches)
                    INPUT.VALUE.FRAME = frame_matches{1};
                end

            else
                fprintf('%s\n', 'INVALID DESIGN OPTION')
            end

         

    elseif strcmp(INPUT.MODE, 'propagation')
            INPUT.TREND     = struct('QUAT', [], 'ECI', [],...
                                     'LLA', [], 'ECLI', [], 'SUN', []);
            
            patterns.QUAT       = 'QUAT\s+''(.*?)''';
            patterns.ECI        = 'ECI\s+''(.*?)''';
            patterns.LLA        = 'LLA\s+''(.*?)''';
            patterns.ECLIPSE    = 'ECLIPSE\s+''(.*?)''';
            patterns.SUN        = 'SUN\s+''(.*?)''';

            Q_matches           = regexp(file_content, patterns.QUAT, 'tokens', 'once');
            ECI_matches         = regexp(file_content, patterns.ECI, 'tokens', 'once');
            LLA_matches         = regexp(file_content, patterns.LLA, 'tokens', 'once');
            ECLIPSE_matches     = regexp(file_content, patterns.ECLIPSE, 'tokens', 'once');
            SUN_matches         = regexp(file_content, patterns.SUN, 'tokens', 'once');
            
            Q_file           = Q_matches{1};
            [~, temp]        = import(Q_file, '%s%f%f%f%f');
            INPUT.TREND.QUAT = temp(2:16:89*16,1:4);
            
            ECI_file = ECI_matches{1};
            [~, INPUT.TREND.ECI] = import(ECI_file, '%s%f%f%f%f');
            
            LLA_file = LLA_matches{1};
            [INPUT.TREND.DATE, INPUT.TREND.LLA] = import(LLA_file, '%s%f%f');
            
            ECLIPSE_file = ECLIPSE_matches{1};
            [~, INPUT.TREND.ECLI] = import(ECLIPSE_file, '%s%f');
            
            SUN_FILE = SUN_matches{1};
            [~, INPUT.TREND.SUN] = import(SUN_FILE, '%s%f%f%f');

    end

    

end


