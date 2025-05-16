function save_dxf_entities(filename)
    fid = fopen(filename, 'r');
    if fid == -1
        error('Could not open file.');
    end

    lines = {};
    arcs = [];
    current_entity = '';
    data = struct();

    while ~feof(fid)
        code = strtrim(fgetl(fid));
        if feof(fid), break; end
        value = strtrim(fgetl(fid));

        switch code
            case '0'
                if strcmp(current_entity, 'LINE') && isfield(data, 'x1')
                    lines{end+1} = data;
                elseif strcmp(current_entity, 'ARC') && isfield(data, 'start_angle') && isfield(data, 'end_angle')
                    arcs = [arcs; data];
                end
                current_entity = value;
                data = struct();

            case '10'
                if strcmp(current_entity, 'LINE')
                    data.x1 = str2double(value);
                elseif strcmp(current_entity, 'ARC')
                    data.cx = str2double(value);
                end
            case '20'
                if strcmp(current_entity, 'LINE')
                    data.y1 = str2double(value);
                elseif strcmp(current_entity, 'ARC')
                    data.cy = str2double(value);
                end
            case '11'
                if strcmp(current_entity, 'LINE')
                    data.x2 = str2double(value);
                end
            case '21'
                if strcmp(current_entity, 'LINE')
                    data.y2 = str2double(value);
                end
            case '40'
                if strcmp(current_entity, 'ARC')
                    data.r = str2double(value);
                end
            case '50'
                if strcmp(current_entity, 'ARC')
                    data.start_angle = str2double(value);
                end
            case '51'
                if strcmp(current_entity, 'ARC')
                    data.end_angle = str2double(value);
                end
        end
    end

    fclose(fid);

    % Final entity check
    if strcmp(current_entity, 'LINE') && isfield(data, 'x1')
        lines{end+1} = data;
    elseif strcmp(current_entity, 'ARC') && isfield(data, 'start_angle') && isfield(data, 'end_angle')
        arcs = [arcs; data];
    end

    % Convert cell array of lines to struct array
    lines_struct = cell2mat(cellfun(@(x) x, lines, 'UniformOutput', false));

    % Save both entities
    save('dxf_lines.mat', 'lines_struct');
    save('dxf_arcs.mat', 'arcs');

    fprintf('Saved %d lines and %d arcs to .mat files.\n', length(lines), size(arcs,1));
end
