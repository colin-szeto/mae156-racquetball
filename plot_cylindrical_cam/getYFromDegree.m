function [y, segment] = getYFromDegree(degree)
    % This function returns the Y-value and the segment type ('red' or 'green')
    % for a given degree value based on the plot's shape.

    % Normalize degree to [0, 120)
    local_deg = mod(degree, 120);

    % Parameters (based on plot estimation)
    y_start = 0;
    y_end = 37.5; % max linear travel per 120 degrees
    green_start = 10;
    green_end = 110;

    if local_deg < green_start
        % Red segment (bottom curve)
        t = local_deg / green_start;
        y = y_start + (y_end / 3) * (t^2); % Quadratic approximation
        segment = "red";

    elseif local_deg <= green_end
        % Green linear segment
        slope = (y_end - y_start) / (green_end - green_start);
        y = y_start + slope * (local_deg - green_start);
        segment = "green";

    else
        % Red segment (top curve)
        t = (local_deg - green_end) / (120 - green_end);
        y = y_end - (y_end / 3) * (t^2); % Quadratic approximation
        segment = "red";
    end
end
