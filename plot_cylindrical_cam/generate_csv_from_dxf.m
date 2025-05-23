clear; clc;

% Load your .mat files
load('dxf_arcs.mat');
load('dxf_lines.mat');

% Set up
num_segments = 3;                % 3x 120° segments = 360°
n_points_per_segment = 500;
total_points = num_segments * n_points_per_segment;

% Determine pattern width
x_min = inf; x_max = -inf;
for i = 1:length(lines_struct)
    l = lines_struct(i);
    x_min = min([x_min, l.x1, l.x2]);
    x_max = max([x_max, l.x1, l.x2]);
end
for i = 1:length(arcs)
    a = arcs(i);
    theta = linspace(a.start_angle, a.end_angle, 100);
    x_arc = a.cx + a.r * cosd(theta);
    x_min = min(x_min, min(x_arc));
    x_max = max(x_max, max(x_arc));
end
pattern_width = x_max - x_min;

% Normalize Y offset
y_min = inf;
for i = 1:length(lines_struct)
    l = lines_struct(i);
    y_min = min([y_min, l.y1, l.y2]);
end
for i = 1:length(arcs)
    a = arcs(i);
    theta = linspace(a.start_angle, a.end_angle, 100);
    y_arc = a.cy + a.r * sind(theta);
    y_min = min(y_min, min(y_arc));
end
y_offset = y_min;

% Sample X range across all segments
x_samples = linspace(0, num_segments * pattern_width, total_points);
y_samples = zeros(size(x_samples));

% Sample Y value at each X by tracing top surface
for i = 1:length(x_samples)
    x = x_samples(i);
    y_max = -inf;

    % Check lines
    for j = 1:length(lines_struct)
        l = lines_struct(j);
        x1 = l.x1; x2 = l.x2;
        y1 = l.y1; y2 = l.y2;

        if x1 == x2 && abs(x - x1) < 1e-3
            y_here = max(y1, y2);
        elseif (x >= min(x1, x2)) && (x <= max(x1, x2))
            t = (x - x1) / (x2 - x1);
            y_here = y1 + t * (y2 - y1);
        else
            continue;
        end
        if ~isnan(y_here)
            y_max = max(y_max, y_here);
        end
    end

    % Check arcs
    for j = 1:length(arcs)
        a = arcs(j);
        theta = linspace(a.start_angle, a.end_angle, 100);
        x_arc = a.cx + a.r * cosd(theta);
        y_arc = a.cy + a.r * sind(theta);
        [~, idx] = min(abs(x_arc - x));
        if abs(x_arc(idx) - x) < 0.5
            y_max = max(y_max, y_arc(idx));
        end
    end

    % Store
    y_samples(i) = y_max - y_offset;
end

% Map X sample to degrees
theta_deg = linspace(0, 360, total_points);

% Write to CSV
T = table(theta_deg', y_samples', 'VariableNames', {'theta_deg', 'linear_travel_mm'});
writetable(T, 'cam_displacement_from_dxf.csv');

disp('CSV exported: cam_displacement_from_dxf.csv');
