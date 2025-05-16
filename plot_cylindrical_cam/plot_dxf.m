function plot_dxf(filename)
    fid = fopen(filename, 'r');
    if fid == -1
        error('Could not open file.');
    end

       % Initialize flags and storage
    lines = {};
    arcs = [];
    current_entity = '';
    data = struct();

    while ~feof(fid)
        code = strtrim(fgetl(fid));
        if feof(fid)
            break;
        end
        value = strtrim(fgetl(fid));

        switch code
            case '0'
                % Save previous entity if complete
                if strcmp(current_entity, 'LINE') && isfield(data, 'x1')
                    lines{end+1} = data;
                elseif strcmp(current_entity, 'ARC') && isfield(data, 'start_angle') && isfield(data, 'end_angle')
                    arcs = [arcs; data];
                end
                % Start new entity
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

    % Final entity check after file ends
    if strcmp(current_entity, 'LINE') && isfield(data, 'x1')
        lines{end+1} = data;
    elseif strcmp(current_entity, 'ARC') && isfield(data, 'start_angle') && isfield(data, 'end_angle')
        arcs = [arcs; data];
    end


    % Plotting
    figure; hold on; axis equal;
    for k = 1:length(lines)
        l = lines{k};
        plot([l.x1 l.x2], [l.y1 l.y2], 'g-');
    end

    for k = 1:length(arcs)
        a = arcs(k);
        theta = linspace(deg2rad(a.start_angle), deg2rad(a.end_angle), 100);
        x = a.cx + a.r * cos(theta);
        y = a.cy + a.r * sin(theta);
        plot(x, y, 'r-');
    end

    title('DXF Plot');
    xlabel('X');
    ylabel('Y');
    grid on
    hold off
end
