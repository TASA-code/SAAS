function structdisp(s, indent)
    if nargin < 2
        indent = '|-';
    end
    
    fields = fieldnames(s);
    for i = 1:length(fields)
        field = fields{i};
        value = s.(field);
        
        if isstruct(value)
            fprintf('%s%s:\t\n', indent, field);
            structdisp(value, [indent '       ']);
        elseif ischar(value)
            fprintf('%s%s: \t%s\n', indent, field, value);
        elseif isnumeric(value) && ismatrix(value) || isdatetime(value)
            [rows, cols] = size(value);
            if rows <= 3
                fprintf('%s%s: \t%s\n', indent, field, mat2str(value));
            else
                fprintf('%s%s: \t[%dx%d %s]\n', indent, field, rows, cols, class(value));
            end
        else
            fprintf('%s%s: \t%s\n', indent, field, mat2str(value));
        end
    end
    fprintf('%s\n', '');
end