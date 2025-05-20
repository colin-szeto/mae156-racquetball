clear; close all; clc;

% Load and scale to mm
cam1_profile = load('cam1_profile.csv');
x_cam = cam1_profile(:,1)';
y_cam = cam1_profile(:,2)';
x1 = x_cam;
y1 = y_cam;

% Rotated copies (120°, 240°)
theta_offsets = [120, 240];
x_all = {x1};
y_all = {y1};

for angle = theta_offsets
    R = [cosd(angle), -sind(angle); sind(angle), cosd(angle)];
    rotated = R * [x1; y1];
    x_all{end+1} = rotated(1,:);
    y_all{end+1} = rotated(2,:);
end

% === Automatically detect flat/linear "chord" segment ===
% Use angle between adjacent segments
dx = diff(x1);
dy = diff(y1);
angles = atan2d(dy, dx);
angles = mod(angles, 360);  % Keep in [0, 360)
dtheta = abs(diff(angles));
dtheta(dtheta > 180) = 360 - dtheta(dtheta > 180);  % unwrap angle

% Find straight (sharp transition) segments based on angle change
curvature_thresh = 6;  % degrees
linear_idx = find(dtheta < curvature_thresh);

% Group into contiguous segments
group_start = [];
group_end = [];
min_len = 5;

i = 1;
while i < length(linear_idx)
    start_i = i;
    while i < length(linear_idx)-1 && linear_idx(i+1) == linear_idx(i)+1
        i = i + 1;
    end
    if (i - start_i + 1) >= min_len
        group_start(end+1) = linear_idx(start_i);
        group_end(end+1) = linear_idx(i)+1;
    end
    i = i + 1;
end

% === Plotting ===
figure; hold on;
styles = {'b-', 'r--', 'g-.'};
labels = {}%{'Original (0°)', 'Rotated (120°)', 'Rotated (240°)'};

%for i = 1:3
%    plot(x_all{i}, y_all{i}, styles{i}, 'LineWidth', 2);
%end

% Highlight the straight/flat segments in magenta
for k = 1:length(group_start)
    idx_range = group_start(k):group_end(k);
    for i = 1:3
        plot(x_all{i}(idx_range), y_all{i}(idx_range), 'm-', 'LineWidth', 4);
    end
end

axis equal; grid on; box on;
legend([labels, {'Highlighted Flat Sides'}], 'Location', 'Best');
title('Cam Profile with Automatically Highlighted Flat Sides');
xlabel('X [mm]');
ylabel('Y [mm]');
